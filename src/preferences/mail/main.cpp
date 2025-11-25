/*
 * Copyright 2011, Plasmatail, Inc. All rights reserved.
 * Copyright 2011, Clemens Zeidler <haiku@clemens-zeidler.de>
 * Distributed under the terms of the MIT License.
 */


#include <Application.h>

#include "ConfigWindow.h"


int
main(int argc, char** argv)
{
	BApplication app("application/x-vnd.Plasmatail-Mail");

	BWindow* window = new ConfigWindow;
	window->Show();

	app.Run();
	return 0;
}
