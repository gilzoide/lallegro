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

/** Allegro Video Streaming addon **/
%module lallegro_video

%include "common.i"

%{
#include <allegro5/allegro_video.h>
%}

/* Manually included functions, as SWIG is only preprocessing
 * ALLEGRO_VIDEO_FUNC to AL_FUNC, and complaining that AL_FUNC isn't valid
 * C
 */
bool al_init_video_addon(void);

void al_shutdown_video_addon(void);

uint32_t al_get_allegro_video_version(void);

ALLEGRO_VIDEO *al_open_video(char const *filename);

void al_close_video(ALLEGRO_VIDEO *video);

void al_start_video(ALLEGRO_VIDEO *video, ALLEGRO_MIXER *mixer);

void al_start_video_with_voice(ALLEGRO_VIDEO *video, ALLEGRO_VOICE *voice);

ALLEGRO_EVENT_SOURCE *al_get_video_event_source(ALLEGRO_VIDEO *video);

void al_set_video_playing(ALLEGRO_VIDEO *video, bool play);

bool al_is_video_playing(ALLEGRO_VIDEO *video);

double al_get_video_audio_rate(ALLEGRO_VIDEO *video);

double al_get_video_fps(ALLEGRO_VIDEO *video);

float al_get_video_scaled_width(ALLEGRO_VIDEO *video);

float al_get_video_scaled_height(ALLEGRO_VIDEO *video);

ALLEGRO_BITMAP *al_get_video_frame(ALLEGRO_VIDEO *video);

double al_get_video_position(ALLEGRO_VIDEO *video, ALLEGRO_VIDEO_POSITION_TYPE which);

bool al_seek_video(ALLEGRO_VIDEO *video, double pos_in_seconds);

////////////////////////////////////////////////////////////////////////////////
// Macros and Enums, again by hand
enum ALLEGRO_VIDEO_EVENT_TYPE
{
   ALLEGRO_EVENT_VIDEO_FRAME_SHOW   = 550,
   ALLEGRO_EVENT_VIDEO_FINISHED     = 551,
};

enum ALLEGRO_VIDEO_POSITION_TYPE
{
   ALLEGRO_VIDEO_POSITION_ACTUAL        = 0,
   ALLEGRO_VIDEO_POSITION_VIDEO_DECODE  = 1,
   ALLEGRO_VIDEO_POSITION_AUDIO_DECODE  = 2
};
