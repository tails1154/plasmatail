/*
 * Copyright 2009, Ingo Weinhold, ingo_weinhold@gmx.de.
 * Distributed under the terms of the MIT License.
 */

#include "PlasmatailKernelNode.h"

#include "PlasmatailKernelFileSystem.h"


PlasmatailKernelNode::~PlasmatailKernelNode()
{
	if (capabilities != NULL) {
		PlasmatailKernelFileSystem* fileSystem
			= static_cast<PlasmatailKernelFileSystem*>(FileSystem::GetInstance());
		fileSystem->PutNodeCapabilities(capabilities);
	}
}
