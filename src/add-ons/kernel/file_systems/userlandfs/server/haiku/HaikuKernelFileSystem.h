/*
 * Copyright 2007-2009, Ingo Weinhold, ingo_weinhold@gmx.de.
 * Distributed under the terms of the MIT License.
 */
#ifndef USERLAND_FS_HAIKU_KERNEL_FILE_SYSTEM_H
#define USERLAND_FS_HAIKU_KERNEL_FILE_SYSTEM_H

#include "Locker.h"

#include "PlasmatailKernelNode.h"

#include "../FileSystem.h"


struct file_system_module_info;


namespace UserlandFS {

struct PlasmatailKernelIORequest;

class PlasmatailKernelFileSystem : public FileSystem {
public:
								PlasmatailKernelFileSystem(const char* fsName,
									file_system_module_info* fsModule);
	virtual						~PlasmatailKernelFileSystem();

			status_t			Init();

	virtual	status_t			CreateVolume(Volume** volume, dev_t id);
	virtual	status_t			DeleteVolume(Volume* volume);

			status_t			AddIORequest(PlasmatailKernelIORequest* request);
			PlasmatailKernelIORequest* GetIORequest(int32 requestID);
			void				PutIORequest(PlasmatailKernelIORequest* request,
									int32 refCount = 1);

			PlasmatailKernelNode::Capabilities* GetNodeCapabilities(
									fs_vnode_ops* ops);
			void				PutNodeCapabilities(
									PlasmatailKernelNode::Capabilities*
										capabilities);

private:
	struct IORequestHashDefinition;
	struct IORequestTable;
	struct NodeCapabilitiesHashDefinition;
	struct NodeCapabilitiesTable;

private:
			void				_InitCapabilities();
	static	void				_InitNodeCapabilities(fs_vnode_ops* ops,
									FSVNodeCapabilities& capabilities);

private:
			file_system_module_info* fFSModule;
			IORequestTable*		fIORequests;
			NodeCapabilitiesTable* fNodeCapabilities;
			Locker				fLock;
};

}	// namespace UserlandFS

using UserlandFS::PlasmatailKernelFileSystem;

#endif	// USERLAND_FS_HAIKU_KERNEL_FILE_SYSTEM_H
