/*
 * Copyright 2009, Ingo Weinhold, ingo_weinhold@gmx.de.
 * Distributed under the terms of the MIT License.
 */
#ifndef USERLAND_FS_HAIKU_KERNEL_IO_REQUEST_H
#define USERLAND_FS_HAIKU_KERNEL_IO_REQUEST_H

#include <fs_interface.h>

#include <util/OpenHashTable.h>

#include "../IORequestInfo.h"


namespace UserlandFS {

class PlasmatailKernelVolume;

struct PlasmatailKernelIORequest : IORequestInfo {

	PlasmatailKernelVolume*		volume;
	int32					refCount;
	PlasmatailKernelIORequest*	hashLink;

	PlasmatailKernelIORequest(PlasmatailKernelVolume* volume, const IORequestInfo& info)
		:
		IORequestInfo(info),
		volume(volume),
		refCount(1)
	{
	}
};

struct PlasmatailKernelIterativeFDIOCookie {
	int						fd;
	PlasmatailKernelIORequest*	request;
	iterative_io_get_vecs	getVecs;
	iterative_io_finished	finished;
	void*					cookie;

	PlasmatailKernelIterativeFDIOCookie(int fd, PlasmatailKernelIORequest* request,
		iterative_io_get_vecs getVecs, iterative_io_finished finished,
		void* cookie)
		:
		fd(fd),
		request(request),
		getVecs(getVecs),
		finished(finished),
		cookie(cookie)
	{
	}
};

}	// namespace UserlandFS


using UserlandFS::PlasmatailKernelIORequest;
using UserlandFS::PlasmatailKernelIterativeFDIOCookie;


#endif	// USERLAND_FS_HAIKU_KERNEL_IO_REQUEST_H
