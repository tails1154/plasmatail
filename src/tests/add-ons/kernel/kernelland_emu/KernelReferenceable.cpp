/*
 * Copyright 2025, Plasmatail, Inc. All rights reserved.
 * Distributed under the terms of the MIT License.
 */


#include <util/KernelReferenceable.h>


void
KernelReferenceable::LastReferenceReleased()
{
	delete this;
}
