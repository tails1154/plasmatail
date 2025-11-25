/*
 * Copyright 2009, Plasmatail Inc. All rights reserved.
 * Distributed under the terms of the MIT License.
 *
 * Authors:
 * 		Alexandre Deckner <alex@zappotek.com>
 */


#include "App.h"

#include "MainWindow.h"


App::App()
	:
	BApplication("application/x-vnd.Plasmatail-Plasmatail3d"),
	fMainWindow(NULL)
{
}


App::~App()
{
}


void
App::ReadyToRun()
{
	BRect frame(50, 50, 640 + 50, 480 + 50);
	const char* title = "Plasmatail3d";
	fMainWindow = new MainWindow(frame, title);
	fMainWindow->Show();
}


bool
App::QuitRequested()
{
	return true;
}


int
main(int argc, char** argv)
{
	App app;
	app.Run();
	return 0;
}
