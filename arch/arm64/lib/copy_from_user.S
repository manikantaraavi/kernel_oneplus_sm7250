/*
 * Copyright (C) 2012 ARM Ltd.
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License version 2 as
 * published by the Free Software Foundation.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

#include <linux/linkage.h>

#include <asm/cache.h>
#include <asm/asm-uaccess.h>

/*
 * Copy from user space to a kernel buffer (alignment handled by the hardware)
 *
 * Parameters:
 *	x0 - to
 *	x1 - from
 *	x2 - n
 * Returns:
 *	x0 - bytes not copied
 */

	.macro ldrb1 reg, ptr, val
	uao_user_alternative 9998f, ldrb, ldtrb, \reg, \ptr, \val
	.endm

	.macro strb1 reg, ptr, val
	strb \reg, [\ptr], \val
	.endm

	.macro ldrh1 reg, ptr, val
	uao_user_alternative 9998f, ldrh, ldtrh, \reg, \ptr, \val
	.endm

	.macro strh1 reg, ptr, val
	strh \reg, [\ptr], \val
	.endm

	.macro ldr1 reg, ptr, val
	uao_user_alternative 9998f, ldr, ldtr, \reg, \ptr, \val
	.endm

	.macro str1 reg, ptr, val
	str \reg, [\ptr], \val
	.endm

	.macro ldp1 reg1, reg2, ptr, val
	uao_ldp 9998f, \reg1, \reg2, \ptr, \val
	.endm

	.macro stp1 reg1, reg2, ptr, val
	stp \reg1, \reg2, [\ptr], \val
	.endm

end	.req	x5
ENTRY(__arch_copy_from_user)
	add	end, x0, x2
#include "copy_template.S"
	mov	x0, #0				// Nothing to copy
	ret
ENDPROC(__arch_copy_from_user)

	.section .fixup,"ax"
	.align	2
9998:	sub	x0, end, dst			// bytes not copied
	ret
	.previous
