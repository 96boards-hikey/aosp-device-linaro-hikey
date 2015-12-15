//
//  Copyright (c) 2011-2012, ARM Limited. All rights reserved.
//  Copyright (c) Huawei Technologies Co., Ltd. 2013. All rights reserved.
//  
//  This program and the accompanying materials                          
//  are licensed and made available under the terms and conditions of the BSD License         
//  which accompanies this distribution.  The full text of the license may be found at        
//  http://opensource.org/licenses/bsd-license.php                                            
//
//  THE PROGRAM IS DISTRIBUTED UNDER THE BSD LICENSE ON AN "AS IS" BASIS,                     
//  WITHOUT WARRANTIES OR REPRESENTATIONS OF ANY KIND, EITHER EXPRESS OR IMPLIED.             
//
//

#include <AutoGen.h>
#include <AsmMacroIoLib.h>
#include "SecInternal.h"

  INCLUDE AsmMacroIoLib.inc
  
  IMPORT  CEntryPoint
  IMPORT  ArmPlatformSecBootAction
  IMPORT  ArmPlatformSecBootMemoryInit
  IMPORT  ArmDisableInterrupts
  IMPORT  ArmDisableCachesAndMmu
  IMPORT  ArmReadMpidr
  IMPORT  ArmCallWFE
  EXPORT  _ModuleEntryPoint

  PRESERVE8
  AREA    SecEntryPoint, CODE, READONLY
  
StartupAddr        DCD      CEntryPoint
CTRL_M_BIT		EQU 	(1 << 0)
CTRL_C_BIT		EQU 	(1 << 2)
CTRL_B_BIT		EQU 	(1 << 7)
CTRL_I_BIT		EQU 	(1 << 12)

_ModuleEntryPoint FUNCTION
  // First ensure all interrupts are disabled
  ;blx   ArmDisableInterrupts
	cpsie	if
	isb

  // Ensure that the MMU and caches are off
  ;blx   ArmDisableCachesAndMmu
	mrc   p15, 0, r0, c1, c0, 0 		  ; Get control register
	bic	r0, r0, #CTRL_M_BIT 			; Disable MMU
	bic	r0, r0, #CTRL_C_BIT 			; Disable D Cache
	bic	r0, r0, #CTRL_I_BIT 			; Disable I Cache
	mcr	p15, 0, r0, c1, c0, 0			; Write control register
	dsb
	isb

  // By default, we are doing a cold boot
  ;mov   r10, #ARM_SEC_COLD_BOOT

  // Jump to Platform Specific Boot Action function
  blx   ArmPlatformSecBootAction

_IdentifyCpu 
  // Identify CPU ID
  bl    ArmReadMpidr
  // Get ID of this CPU in Multicore system
  LoadConstantToReg (FixedPcdGet32(PcdArmPrimaryCoreMask), r1)
  and   r5, r0, r1
  
  // Is it the Primary Core ?
  LoadConstantToReg (FixedPcdGet32(PcdArmPrimaryCore), r3)
  cmp   r5, r3
  // Only the primary core initialize the memory (SMC)
  beq   _InitMem
  
_WaitInitMem
  // If we are not doing a cold boot in this case we should assume the Initial Memory to be already initialized
  // Otherwise we have to wait the Primary Core to finish the initialization
  cmp   r10, #ARM_SEC_COLD_BOOT
  bne   _SetupSecondaryCoreStack

  // Wait for the primary core to initialize the initial memory (event: BOOT_MEM_INIT)
  bl    ArmCallWFE
  // Now the Init Mem is initialized, we setup the secondary core stacks
  b     _SetupSecondaryCoreStack
  
_InitMem
  // If we are not doing a cold boot in this case we should assume the Initial Memory to be already initialized
  ;cmp   r10, #ARM_SEC_COLD_BOOT
  ;bne   _SetupPrimaryCoreStack

  // Initialize Init Boot Memory
  bl    ArmPlatformSecBootMemoryInit
  
  // Only Primary CPU could run this line (the secondary cores have jumped from _IdentifyCpu to _SetupStack)
  ;LoadConstantToReg (FixedPcdGet32(PcdArmPrimaryCore), r5)

;_SetupPrimaryCoreStack
  ;// Get the top of the primary stacks (and the base of the secondary stacks)
  ;LoadConstantToReg (FixedPcdGet32(PcdCPUCoresSecStackBase), r1)
  ;LoadConstantToReg (FixedPcdGet32(PcdCPUCoreSecPrimaryStackSize), r2)
  ;add   r1, r1, r2

  ;LoadConstantToReg (FixedPcdGet32(PcdSecGlobalVariableSize), r2)

  ;// The reserved space for global variable must be 8-bytes aligned for pushing
  ;// 64-bit variable on the stack
  ;SetPrimaryStack (r1, r2, r3)
  b     _PrepareArguments

_SetupSecondaryCoreStack
  // Get the top of the primary stacks (and the base of the secondary stacks)
  LoadConstantToReg (FixedPcdGet32(PcdCPUCoresSecStackBase), r1)
  LoadConstantToReg (FixedPcdGet32(PcdCPUCoreSecPrimaryStackSize), r2)
  add   r1, r1, r2

  // Get the Core Position (ClusterId * 4) + CoreId
  ;GetCorePositionFromMpId(r0, r5, r2)
  lsr	r0, r5, #6
  and	r2, r5, #3
  add	r0, r0, r2
  // The stack starts at the top of the stack region. Add '1' to the Core Position to get the top of the stack
  add   r0, r0, #1

  // StackOffset = CorePos * StackSize
  LoadConstantToReg (FixedPcdGet32(PcdCPUCoreSecSecondaryStackSize), r2)
  mul   r0, r0, r2
  // SP = StackBase + StackOffset
  add   sp, r1, r0

_PrepareArguments
  // Move sec startup address into a data register
  // Ensure we're jumping to FV version of the code (not boot remapped alias)
  ldr   r3, StartupAddr
  
  ORR	 r3, r3, #(0xf0 << 24)
  ORR	 r3, r3, #(0x10 << 16)
  
  // Jump to SEC C code
  //    r0 = mp_id
  //    r1 = Boot Mode
  mov   r0, r5
  mov   r1, r10
  
  blx   r3
  ENDFUNC
  
_NeverReturn
  b _NeverReturn
  END
