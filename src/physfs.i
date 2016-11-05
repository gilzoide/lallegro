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

/** Allegro PhysicsFS addon **/
%module lallegro_physfs

%include "common.i"

%{
#include <allegro5/allegro_physfs.h>
%}

/* Manually included functions, as SWIG is only preprocessing
 * ALLEGRO_PHYSFS_FUNC to AL_FUNC, and complaining that AL_FUNC isn't valid C
 */
void al_set_physfs_file_interface(void);

uint32_t al_get_allegro_physfs_version(void);
