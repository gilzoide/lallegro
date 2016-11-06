/* Copyright 2016 Gil Barbosa Reis <gilzoide@gmail.com>
 * This file is part of Lallegro.
 *
 * Lallegro is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Lesser General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * Lallegro is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public License
 * along with Lallegro.  If not, see <http://www.gnu.org/licenses/>.
 */

/** Allegro Native Dialog addon **/
%module lallegro_dialog

%include "common.i"

%{
#include <allegro5/allegro_native_dialog.h>
%}

/* Manually included functions, as SWIG is only preprocessing
 * ALLEGRO_DIALOG_FUNC to AL_FUNC, and complaining that AL_FUNC isn't valid C
 */
////////////////////////////////////////////////////////////////////////////////
// Types
typedef struct ALLEGRO_FILECHOOSER ALLEGRO_FILECHOOSER;

typedef struct ALLEGRO_TEXTLOG ALLEGRO_TEXTLOG;

////////////////////////////////////////////////////////////////////////////////
// Native Dialogs
bool al_init_native_dialog_addon(void);

void al_shutdown_native_dialog_addon(void);

ALLEGRO_FILECHOOSER *al_create_native_file_dialog(char const *initial_path
        , char const *title, char const *patterns, int mode);

bool al_show_native_file_dialog(ALLEGRO_DISPLAY *display
        , ALLEGRO_FILECHOOSER *dialog);

int al_get_native_file_dialog_count(const ALLEGRO_FILECHOOSER *dialog);

const char *al_get_native_file_dialog_path(const ALLEGRO_FILECHOOSER *dialog
        , size_t i);

void al_destroy_native_file_dialog(ALLEGRO_FILECHOOSER *dialog);

int al_show_native_message_box(ALLEGRO_DISPLAY *display, char const *title
        , char const *heading, char const *text, char const *buttons, int flags);

ALLEGRO_TEXTLOG *al_open_native_text_log(char const *title, int flags);

void al_close_native_text_log(ALLEGRO_TEXTLOG *textlog);

// This function originally have varargs, but SWIG doesn't like them much.
// Format your string before passing it here, and it's all ok. We assume it'll
// be called from the wrapper, with format as "%s", and the string
%rename al_append_native_text_log _append_native_text_log;
void al_append_native_text_log(ALLEGRO_TEXTLOG *textlog, char const *format
        , char const *text);

ALLEGRO_EVENT_SOURCE *al_get_native_text_log_event_source(ALLEGRO_TEXTLOG *textlog);

uint32_t al_get_allegro_native_dialog_version(void);

////////////////////////////////////////////////////////////////////////////////
// Menus
typedef struct ALLEGRO_MENU ALLEGRO_MENU;

typedef struct ALLEGRO_MENU_INFO;

ALLEGRO_MENU *al_create_menu(void);

ALLEGRO_MENU *al_create_popup_menu(void);

ALLEGRO_MENU *al_build_menu(ALLEGRO_MENU_INFO *info);

int al_append_menu_item(ALLEGRO_MENU *parent, char const *title, uint16_t id
		, int flags, ALLEGRO_BITMAP *icon, ALLEGRO_MENU *submenu);

int al_insert_menu_item(ALLEGRO_MENU *parent, int pos, char const *title
		, uint16_t id, int flags, ALLEGRO_BITMAP *icon, ALLEGRO_MENU *submenu);

bool al_remove_menu_item(ALLEGRO_MENU *menu, int pos);

ALLEGRO_MENU *al_clone_menu(ALLEGRO_MENU *menu);

ALLEGRO_MENU *al_clone_menu_for_popup(ALLEGRO_MENU *menu);

void al_destroy_menu(ALLEGRO_MENU *menu);

const char *al_get_menu_item_caption(ALLEGRO_MENU *menu, int pos);

void al_set_menu_item_caption(ALLEGRO_MENU *menu, int pos, const char *caption);

int al_get_menu_item_flags(ALLEGRO_MENU *menu, int pos);

void al_set_menu_item_flags(ALLEGRO_MENU *menu, int pos, int flags);

#ifdef ALLEGRO_UNSTABLE
int al_toggle_menu_item_flags(ALLEGRO_MENU *menu, int pos, int flags);
#endif

ALLEGRO_BITMAP *al_get_menu_item_icon(ALLEGRO_MENU *menu, int pos);

void al_set_menu_item_icon(ALLEGRO_MENU *menu, int pos, ALLEGRO_BITMAP *icon);

ALLEGRO_MENU *al_find_menu(ALLEGRO_MENU *haystack, uint16_t id);

%apply ALLEGRO_MENU **OUTPUT { ALLEGRO_MENU **menu };
%apply int *OUTPUT { int *index };
bool al_find_menu_item(ALLEGRO_MENU *haystack, uint16_t id, ALLEGRO_MENU **menu
		, int *index);

ALLEGRO_EVENT_SOURCE *al_get_default_menu_event_source(void);

ALLEGRO_EVENT_SOURCE *al_enable_menu_event_source(ALLEGRO_MENU *menu);

void al_disable_menu_event_source(ALLEGRO_MENU *menu);

ALLEGRO_MENU *al_get_display_menu(ALLEGRO_DISPLAY *display);

bool al_set_display_menu(ALLEGRO_DISPLAY *display, ALLEGRO_MENU *menu);

bool al_popup_menu(ALLEGRO_MENU *popup, ALLEGRO_DISPLAY *display);

ALLEGRO_MENU *al_remove_display_menu(ALLEGRO_DISPLAY *display);

////////////////////////////////////////////////////////////////////////////////
// Macros and Enums, again by hand
enum {
   ALLEGRO_FILECHOOSER_FILE_MUST_EXIST = 1,
   ALLEGRO_FILECHOOSER_SAVE            = 2,
   ALLEGRO_FILECHOOSER_FOLDER          = 4,
   ALLEGRO_FILECHOOSER_PICTURES        = 8,
   ALLEGRO_FILECHOOSER_SHOW_HIDDEN     = 16,
   ALLEGRO_FILECHOOSER_MULTIPLE        = 32
};

enum {
   ALLEGRO_MESSAGEBOX_WARN             = 1<<0,
   ALLEGRO_MESSAGEBOX_ERROR            = 1<<1,
   ALLEGRO_MESSAGEBOX_OK_CANCEL        = 1<<2,
   ALLEGRO_MESSAGEBOX_YES_NO           = 1<<3,
   ALLEGRO_MESSAGEBOX_QUESTION         = 1<<4
};

enum {
   ALLEGRO_TEXTLOG_NO_CLOSE            = 1<<0,
   ALLEGRO_TEXTLOG_MONOSPACE           = 1<<1
};

enum {
   ALLEGRO_EVENT_NATIVE_DIALOG_CLOSE   = 600,
   ALLEGRO_EVENT_MENU_CLICK            = 601
};

enum {
   ALLEGRO_MENU_ITEM_ENABLED            = 0,
   ALLEGRO_MENU_ITEM_CHECKBOX           = 1,
   ALLEGRO_MENU_ITEM_CHECKED            = 2,
   ALLEGRO_MENU_ITEM_DISABLED           = 4
};

