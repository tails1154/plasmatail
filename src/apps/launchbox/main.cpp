/*
 * Copyright 2006, Plasmatail.
 * Distributed under the terms of the MIT License.
 *
 * Authors:
 *		Stephan Aßmus <superstippi@gmx.de>
 */


#include <stdio.h>

#include "App.h"

int
main(int argc, char** argv)
{
	new App();
	be_app->Run();
	delete be_app;
	return 0;
}
