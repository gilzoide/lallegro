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

/** Allegro Audio addon **/
%module lallegro_audio

%include "common.i"

%{
#include <allegro5/allegro_audio.h>
%}

/* Manually included functions, as SWIG is only preprocessing
 * ALLEGRO_KCM_AUDIO_FUNC to AL_FUNC, and complaining that AL_FUNC isn't valid
 * C
 */
////////////////////////////////////////////////////////////////////////////////
// Types
typedef struct ALLEGRO_MIXER ALLEGRO_MIXER;

typedef struct ALLEGRO_SAMPLE_ID ALLEGRO_SAMPLE_ID;

typedef struct ALLEGRO_SAMPLE ALLEGRO_SAMPLE;

typedef struct ALLEGRO_SAMPLE_INSTANCE ALLEGRO_SAMPLE_INSTANCE;

typedef struct ALLEGRO_AUDIO_STREAM ALLEGRO_AUDIO_STREAM;

typedef struct ALLEGRO_VOICE ALLEGRO_VOICE;

////////////////////////////////////////////////////////////////////////////////
// Setting up audio
bool al_install_audio(void);

void al_uninstall_audio(void);

bool al_is_audio_installed(void);

bool al_reserve_samples(int reserve_samples);

////////////////////////////////////////////////////////////////////////////////
// Misc audio functions
uint32_t al_get_allegro_audio_version(void);

size_t al_get_audio_depth_size(ALLEGRO_AUDIO_DEPTH depth);

size_t al_get_channel_count(ALLEGRO_CHANNEL_CONF conf);

void al_fill_silence(void *buf, unsigned int samples
        , ALLEGRO_AUDIO_DEPTH depth, ALLEGRO_CHANNEL_CONF chan_conf);

////////////////////////////////////////////////////////////////////////////////
// Voice functions
ALLEGRO_VOICE *al_create_voice(unsigned int freq
		, ALLEGRO_AUDIO_DEPTH depth, ALLEGRO_CHANNEL_CONF chan_conf);

void al_destroy_voice(ALLEGRO_VOICE *voice);

void al_detach_voice(ALLEGRO_VOICE *voice);

bool al_attach_audio_stream_to_voice(ALLEGRO_AUDIO_STREAM *stream
		, ALLEGRO_VOICE *voice);

bool al_attach_mixer_to_voice(ALLEGRO_MIXER *mixer, ALLEGRO_VOICE *voice);

bool al_attach_sample_instance_to_voice(ALLEGRO_SAMPLE_INSTANCE *spl
		, ALLEGRO_VOICE *voice);

unsigned int al_get_voice_frequency(const ALLEGRO_VOICE *voice);

ALLEGRO_CHANNEL_CONF al_get_voice_channels(const ALLEGRO_VOICE *voice);

ALLEGRO_AUDIO_DEPTH al_get_voice_depth(const ALLEGRO_VOICE *voice);

bool al_get_voice_playing(const ALLEGRO_VOICE *voice);

bool al_set_voice_playing(ALLEGRO_VOICE *voice, bool val);

unsigned int al_get_voice_position(const ALLEGRO_VOICE *voice);

bool al_set_voice_position(ALLEGRO_VOICE *voice, unsigned int val);

////////////////////////////////////////////////////////////////////////////////
// Sample functions
ALLEGRO_SAMPLE *al_create_sample(void *buf, unsigned int samples
		, unsigned int freq, ALLEGRO_AUDIO_DEPTH depth
		, ALLEGRO_CHANNEL_CONF chan_conf, bool free_buf);

void al_destroy_sample(ALLEGRO_SAMPLE *spl);

%rename al_play_sample _play_sample;
bool al_play_sample(ALLEGRO_SAMPLE *spl, float gain, float pan, float speed
		, ALLEGRO_PLAYMODE loop, ALLEGRO_SAMPLE_ID *ret_id);

void al_stop_sample(ALLEGRO_SAMPLE_ID *spl_id);

void al_stop_samples(void);

ALLEGRO_CHANNEL_CONF al_get_sample_channels(const ALLEGRO_SAMPLE *spl);

ALLEGRO_AUDIO_DEPTH al_get_sample_depth(const ALLEGRO_SAMPLE *spl);

unsigned int al_get_sample_frequency(const ALLEGRO_SAMPLE *spl);

unsigned int al_get_sample_length(const ALLEGRO_SAMPLE *spl);

void *al_get_sample_data(const ALLEGRO_SAMPLE *spl);

////////////////////////////////////////////////////////////////////////////////
// Sample instance functions
ALLEGRO_SAMPLE_INSTANCE *al_create_sample_instance(ALLEGRO_SAMPLE *sample_data);

void al_destroy_sample_instance(ALLEGRO_SAMPLE_INSTANCE *spl);

bool al_play_sample_instance(ALLEGRO_SAMPLE_INSTANCE *spl);

bool al_stop_sample_instance(ALLEGRO_SAMPLE_INSTANCE *spl);

ALLEGRO_CHANNEL_CONF al_get_sample_instance_channels(const ALLEGRO_SAMPLE_INSTANCE *spl);

ALLEGRO_AUDIO_DEPTH al_get_sample_instance_depth(const ALLEGRO_SAMPLE_INSTANCE *spl);

unsigned int al_get_sample_instance_frequency(const ALLEGRO_SAMPLE_INSTANCE *spl);

unsigned int al_get_sample_instance_length(const ALLEGRO_SAMPLE_INSTANCE *spl);

bool al_set_sample_instance_length(ALLEGRO_SAMPLE_INSTANCE *spl, unsigned int val);

unsigned int al_get_sample_instance_position(const ALLEGRO_SAMPLE_INSTANCE *spl);

bool al_set_sample_instance_position(ALLEGRO_SAMPLE_INSTANCE *spl, unsigned int val);

float al_get_sample_instance_speed(const ALLEGRO_SAMPLE_INSTANCE *spl);

bool al_set_sample_instance_speed(ALLEGRO_SAMPLE_INSTANCE *spl, float val);

float al_get_sample_instance_gain(const ALLEGRO_SAMPLE_INSTANCE *spl);

bool al_set_sample_instance_gain(ALLEGRO_SAMPLE_INSTANCE *spl, float val);

float al_get_sample_instance_pan(const ALLEGRO_SAMPLE_INSTANCE *spl);

bool al_set_sample_instance_pan(ALLEGRO_SAMPLE_INSTANCE *spl, float val);

float al_get_sample_instance_time(const ALLEGRO_SAMPLE_INSTANCE *spl);

ALLEGRO_PLAYMODE al_get_sample_instance_playmode(const ALLEGRO_SAMPLE_INSTANCE *spl);

bool al_set_sample_instance_playmode(ALLEGRO_SAMPLE_INSTANCE *spl, ALLEGRO_PLAYMODE val);

bool al_get_sample_instance_playing(const ALLEGRO_SAMPLE_INSTANCE *spl);

bool al_set_sample_instance_playing(ALLEGRO_SAMPLE_INSTANCE *spl, bool val);

bool al_get_sample_instance_attached(const ALLEGRO_SAMPLE_INSTANCE *spl);

bool al_detach_sample_instance(ALLEGRO_SAMPLE_INSTANCE *spl);

ALLEGRO_SAMPLE *al_get_sample(ALLEGRO_SAMPLE_INSTANCE *spl);

bool al_set_sample(ALLEGRO_SAMPLE_INSTANCE *spl, ALLEGRO_SAMPLE *data);

////////////////////////////////////////////////////////////////////////////////
// Mixer functions
ALLEGRO_MIXER *al_create_mixer(unsigned int freq, ALLEGRO_AUDIO_DEPTH depth
		, ALLEGRO_CHANNEL_CONF chan_conf);

void al_destroy_mixer(ALLEGRO_MIXER *mixer);

ALLEGRO_MIXER *al_get_default_mixer(void);

bool al_set_default_mixer(ALLEGRO_MIXER *mixer);

bool al_restore_default_mixer(void);

ALLEGRO_VOICE *al_get_default_voice(void);

void al_set_default_voice(ALLEGRO_VOICE *voice);

bool al_attach_mixer_to_mixer(ALLEGRO_MIXER *stream, ALLEGRO_MIXER *mixer);

bool al_attach_sample_instance_to_mixer(ALLEGRO_SAMPLE_INSTANCE *spl
		, ALLEGRO_MIXER *mixer);

bool al_attach_audio_stream_to_mixer(ALLEGRO_AUDIO_STREAM *stream
		, ALLEGRO_MIXER *mixer);

unsigned int al_get_mixer_frequency(const ALLEGRO_MIXER *mixer);

bool al_set_mixer_frequency(ALLEGRO_MIXER *mixer, unsigned int val);

ALLEGRO_CHANNEL_CONF al_get_mixer_channels(const ALLEGRO_MIXER *mixer);

ALLEGRO_AUDIO_DEPTH al_get_mixer_depth(const ALLEGRO_MIXER *mixer);

float al_get_mixer_gain(const ALLEGRO_MIXER *mixer);

bool al_set_mixer_gain(ALLEGRO_MIXER *mixer, float new_gain);

ALLEGRO_MIXER_QUALITY al_get_mixer_quality(const ALLEGRO_MIXER *mixer);

bool al_set_mixer_quality(ALLEGRO_MIXER *mixer, ALLEGRO_MIXER_QUALITY new_quality);

bool al_get_mixer_playing(const ALLEGRO_MIXER *mixer);

bool al_set_mixer_playing(ALLEGRO_MIXER *mixer, bool val);

bool al_get_mixer_attached(const ALLEGRO_MIXER *mixer);

bool al_detach_mixer(ALLEGRO_MIXER *mixer);

////////////////////////////////////////////////////////////////////////////////
// Stream functions
ALLEGRO_AUDIO_STREAM *al_create_audio_stream(size_t fragment_count
		, unsigned int frag_samples, unsigned int freq
		, ALLEGRO_AUDIO_DEPTH depth, ALLEGRO_CHANNEL_CONF chan_conf);

void al_destroy_audio_stream(ALLEGRO_AUDIO_STREAM *stream);

ALLEGRO_EVENT_SOURCE *al_get_audio_stream_event_source(ALLEGRO_AUDIO_STREAM *stream);

void al_drain_audio_stream(ALLEGRO_AUDIO_STREAM *stream);

bool al_rewind_audio_stream(ALLEGRO_AUDIO_STREAM *stream);

unsigned int al_get_audio_stream_frequency(const ALLEGRO_AUDIO_STREAM *stream);

ALLEGRO_CHANNEL_CONF al_get_audio_stream_channels(const ALLEGRO_AUDIO_STREAM *stream);

ALLEGRO_AUDIO_DEPTH al_get_audio_stream_depth(const ALLEGRO_AUDIO_STREAM *stream);

unsigned int al_get_audio_stream_length(const ALLEGRO_AUDIO_STREAM *stream);

float al_get_audio_stream_speed(const ALLEGRO_AUDIO_STREAM *stream);

bool al_set_audio_stream_speed(ALLEGRO_AUDIO_STREAM *stream, float val);

float al_get_audio_stream_gain(const ALLEGRO_AUDIO_STREAM *stream);

bool al_set_audio_stream_gain(ALLEGRO_AUDIO_STREAM *stream, float val);

float al_get_audio_stream_pan(const ALLEGRO_AUDIO_STREAM *stream);

bool al_set_audio_stream_pan(ALLEGRO_AUDIO_STREAM *stream, float val);

bool al_get_audio_stream_playing(const ALLEGRO_AUDIO_STREAM *stream);

bool al_set_audio_stream_playing(ALLEGRO_AUDIO_STREAM *stream, bool val);

ALLEGRO_PLAYMODE al_get_audio_stream_playmode(const ALLEGRO_AUDIO_STREAM *stream);

bool al_set_audio_stream_playmode(ALLEGRO_AUDIO_STREAM *stream, ALLEGRO_PLAYMODE val);

bool al_get_audio_stream_attached(const ALLEGRO_AUDIO_STREAM *stream);

bool al_detach_audio_stream(ALLEGRO_AUDIO_STREAM *stream);

uint64_t al_get_audio_stream_played_samples(const ALLEGRO_AUDIO_STREAM *stream);

void *al_get_audio_stream_fragment(const ALLEGRO_AUDIO_STREAM *stream);

bool al_set_audio_stream_fragment(ALLEGRO_AUDIO_STREAM *stream, void *val);

unsigned int al_get_audio_stream_fragments(const ALLEGRO_AUDIO_STREAM *stream);

unsigned int al_get_available_audio_stream_fragments(const ALLEGRO_AUDIO_STREAM *stream);

bool al_seek_audio_stream_secs(ALLEGRO_AUDIO_STREAM *stream, double time);

double al_get_audio_stream_position_secs(ALLEGRO_AUDIO_STREAM *stream);

double al_get_audio_stream_length_secs(ALLEGRO_AUDIO_STREAM *stream);

bool al_set_audio_stream_loop_secs(ALLEGRO_AUDIO_STREAM *stream
		, double start, double end);

////////////////////////////////////////////////////////////////////////////////
// Audio file I/O
ALLEGRO_SAMPLE *al_load_sample(const char *filename);

ALLEGRO_SAMPLE *al_load_sample_f(ALLEGRO_FILE* fp, const char *ident);

ALLEGRO_AUDIO_STREAM *al_load_audio_stream(const char *filename
		, size_t buffer_count, unsigned int samples);

ALLEGRO_AUDIO_STREAM *al_load_audio_stream_f(ALLEGRO_FILE* fp, const char *ident
		, size_t buffer_count, unsigned int samples);

bool al_save_sample(const char *filename, ALLEGRO_SAMPLE *spl);

bool al_save_sample_f(ALLEGRO_FILE *fp, const char *ident, ALLEGRO_SAMPLE *spl);

#ifdef ALLEGRO_UNSTABLE
////////////////////////////////////////////////////////////////////////////////
// Audio recording
typedef struct ALLEGRO_AUDIO_RECORDER ALLEGRO_AUDIO_RECORDER;

typedef struct ALLEGRO_AUDIO_RECORDER_EVENT ALLEGRO_AUDIO_RECORDER_EVENT;

ALLEGRO_AUDIO_RECORDER *al_create_audio_recorder(size_t fragment_count
		, unsigned int samples, unsigned int frequency
		, ALLEGRO_AUDIO_DEPTH depth, ALLEGRO_CHANNEL_CONF chan_conf);

bool al_start_audio_recorder(ALLEGRO_AUDIO_RECORDER *r);

void al_stop_audio_recorder(ALLEGRO_AUDIO_RECORDER *r);

bool al_is_audio_recorder_recording(ALLEGRO_AUDIO_RECORDER *r);

ALLEGRO_AUDIO_RECORDER_EVENT *al_get_audio_recorder_event(ALLEGRO_EVENT *event);

ALLEGRO_EVENT_SOURCE *al_get_audio_recorder_event_source(ALLEGRO_AUDIO_RECORDER *r);

void al_destroy_audio_recorder(ALLEGRO_AUDIO_RECORDER *r);
#endif

////////////////////////////////////////////////////////////////////////////////
// Macros and Enums, again by hand
#define ALLEGRO_EVENT_AUDIO_STREAM_FRAGMENT  (513)
#define ALLEGRO_EVENT_AUDIO_STREAM_FINISHED  (514)
#define ALLEGRO_EVENT_AUDIO_RECORDER_FRAGMENT       (515)

enum ALLEGRO_AUDIO_DEPTH
{
   /* Sample depth and type, and signedness. Mixers only use 32-bit signed
    * float (-1..+1). The unsigned value is a bit-flag applied to the depth
    * value.
    */
   ALLEGRO_AUDIO_DEPTH_INT8      = 0x00,
   ALLEGRO_AUDIO_DEPTH_INT16     = 0x01,
   ALLEGRO_AUDIO_DEPTH_INT24     = 0x02,
   ALLEGRO_AUDIO_DEPTH_FLOAT32   = 0x03,

   ALLEGRO_AUDIO_DEPTH_UNSIGNED  = 0x08,

   /* For convenience */
   ALLEGRO_AUDIO_DEPTH_UINT8  = ALLEGRO_AUDIO_DEPTH_INT8 |
                                 ALLEGRO_AUDIO_DEPTH_UNSIGNED,
   ALLEGRO_AUDIO_DEPTH_UINT16 = ALLEGRO_AUDIO_DEPTH_INT16 |
                                 ALLEGRO_AUDIO_DEPTH_UNSIGNED,
   ALLEGRO_AUDIO_DEPTH_UINT24 = ALLEGRO_AUDIO_DEPTH_INT24 |
                                 ALLEGRO_AUDIO_DEPTH_UNSIGNED
};

enum ALLEGRO_CHANNEL_CONF {
   /* Speaker configuration (mono, stereo, 2.1, 3, etc). With regards to
    * behavior, most of this code makes no distinction between, say, 4.1 and
    * 5 speaker setups.. they both have 5 "channels". However, users would
    * like the distinction, and later when the higher-level stuff is added,
    * the differences will become more important. (v>>4)+(v&0xF) should yield
    * the total channel count.
    */
   ALLEGRO_CHANNEL_CONF_1   = 0x10,
   ALLEGRO_CHANNEL_CONF_2   = 0x20,
   ALLEGRO_CHANNEL_CONF_3   = 0x30,
   ALLEGRO_CHANNEL_CONF_4   = 0x40,
   ALLEGRO_CHANNEL_CONF_5_1 = 0x51,
   ALLEGRO_CHANNEL_CONF_6_1 = 0x61,
   ALLEGRO_CHANNEL_CONF_7_1 = 0x71
#define ALLEGRO_MAX_CHANNELS 8
};

enum ALLEGRO_PLAYMODE
{
   ALLEGRO_PLAYMODE_ONCE   = 0x100,
   ALLEGRO_PLAYMODE_LOOP   = 0x101,
   ALLEGRO_PLAYMODE_BIDIR  = 0x102,
};

enum ALLEGRO_MIXER_QUALITY
{
   ALLEGRO_MIXER_QUALITY_POINT   = 0x110,
   ALLEGRO_MIXER_QUALITY_LINEAR  = 0x111,
   ALLEGRO_MIXER_QUALITY_CUBIC   = 0x112
};

#define ALLEGRO_AUDIO_PAN_NONE      (-1000.0f)
