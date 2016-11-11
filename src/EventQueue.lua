--[[ Copyright 2016 Gil Barbosa Reis <gilzoide@gmail.com>
-- This file is part of Lallegro.
--
-- Lallegro is free software: you can redistribute it and/or modify
-- it under the terms of the GNU Lesser General Public License as published by
-- the Free Software Foundation, either version 3 of the License, or
-- (at your option) any later version.
--
-- Lallegro is distributed in the hope that it will be useful,
-- but WITHOUT ANY WARRANTY; without even the implied warranty of
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-- GNU Lesser General Public License for more details.
--
-- You should have received a copy of the GNU Lesser General Public License
-- along with Lallegro.  If not, see <http://www.gnu.org/licenses/>.
--]]

--- @classmod lallegro.EventQueue
-- `ALLEGRO_EVENT_QUEUE` wrapper metatable, a GC enabled object, with nice
-- methods and iterators. EventQueue objects have one instance of
-- `ALLEGRO_EVENT` preallocated for returning information avoiding unnecessary
-- memory operations, so __don't__ free it directly or rely on it after
-- some other method that uses `ALLEGRO_EVENT`s.

local al = require 'lallegro.core'

local EventQueue = {}
-- Let EventQueue objects call the methods
EventQueue.__index = EventQueue
EventQueue.__metatable = 'lallegro.EventQueue'

--------------------------------------------------------------------------------
--  Interface functions
--  @section wrapper
--------------------------------------------------------------------------------

--- Garbage collector should destroy the wrapped `ALLEGRO_EVENT_QUEUE`.
--
-- If you plan to destroy the `ALLEGRO_EVENT_QUEUE` manually, first `extract` it, as
-- `al_destroy_event_queue` would double free the pointer.
function EventQueue:__gc ()
	al.destroy_event_queue (self.data)
end

--- Wraps a `ALLEGRO_EVENT_QUEUE` on a EventQueue object
--
-- @param al_ev_q `ALLEGRO_EVENT_QUEUE` to be wrapped
--
-- @return EventQueue object
function EventQueue.wrap (al_ev_q)
	return al_ev_q and setmetatable ({
		data = al_ev_q,
		event = al.ALLEGRO_EVENT (),
	}, EventQueue)
end

--- Extracts the wrapped `ALLEGRO_EVENT_QUEUE`, so that it will not be GCed.
--
-- This sets the inner `ALLEGRO_EVENT_QUEUE` pointer as `NULL`, so it is not safe
-- to call any other methods after that.
function EventQueue:extract ()
	local al_ev_q = self.data
	self.data = nil
	return al_ev_q
end

--------------------------------------------------------------------------------
--  Construction
--  @section ctor
--------------------------------------------------------------------------------

--- Creates a new EventQueue.
--
-- This is a wrapper for `al_create_event_queue`, and can only be called after
-- initializing Allegro
function EventQueue.new ()
	return EventQueue.wrap (al.create_event_queue ())
end

--------------------------------------------------------------------------------
--  Event sources
--  @section ev_sources
--------------------------------------------------------------------------------

--- Register the event source with the EventQueue.
--
-- This is a wrapper for `al_register_event_source`
function EventQueue:register (source)
	al.register_event_source (self.data, source)
end

--- Unregister the event source with the EventQueue.
--
-- This is a wrapper for `al_unregister_event_source`
function EventQueue:unregister (source)
	al.unregister_event_source (self.data, source)
end

--- Return true if the event source is registered.
--
-- This is a wrapper for `al_is_event_source_registered`
function EventQueue:registered (source)
	return al.is_event_source_registered (self.data, source)
end

--------------------------------------------------------------------------------
--  Pause
--  @section pause
--------------------------------------------------------------------------------

--- Pause or resume EventQueue.
--
-- This is a wrapper for `al_pause_event_queue`
--
-- @bool pause `true` to pause, `false` to resume
function EventQueue:pause (pause)
	al.pause_event_queue (self.data, pause)
end

--- Return true if the EventQueue is paused.
--
-- @treturn bool Is EventQueue paused?
function EventQueue:paused ()
	return al.is_event_queue_paused (self.data)
end

--------------------------------------------------------------------------------
--  Events
--  @section events
--------------------------------------------------------------------------------

--- Return true if the event queue specified is currently empty.
--
-- This is a wrapper for `al_is_event_queue_empty`
function EventQueue:empty ()
	return al.is_event_queue_empty (self.data)
end

--- Pop the next event from EventQueue, if there is one.
--
-- This is a wrapper for `al_get_next_event`
--
-- @treturn[0] ALLEGRO_EVENT Event
-- @treturn[1] nil if EventQueue is empty
function EventQueue:get ()
	return al.get_next_event (self.data, self.event)
			and self.event
			or nil
end

--- Peek the top event from EventQueue, if there is one.
--
-- This is a wrapper for `al_peek_next_event`
--
-- @treturn[0] ALLEGRO_EVENT Event copy
-- @treturn[1] nil if EventQueue is empty
function EventQueue:peek ()
	return al.peek_next_event (self.data, self.event)
			and self.event
			or nil
end

--- Drops the next event from EventQueue, if there is one.
--
-- This is a wrapper for `al_drop_next_event`
--
-- @treturn bool `true` if an event was dropped, `false` otherwise
function EventQueue:drop ()
	return al.drop_next_event (self.data)
end

--- Drops all events, if any, from the EventQueue
function EventQueue:flush ()
	al.flush_event_queue (self.data)
end

--- Wait until the EventQueue is non-empty.
--
-- This is a wrapper for `al_wait_for_event`
--
-- @param[opt] leave_event If `true`, leave the event at the head of the queue, returning `nil`
--
-- @return[0] Event, if `leave_event` is `false` or `nil`
-- @return[1] `nil` otherwise
function EventQueue:wait (leave_event)
	local ev = not leave_event and self.event or nil
	al.wait_for_event (self.data, ev)
	return ev
end

--- Wait until the EventQueue is non-empty.
--
-- This is a wrapper for `al_wait_for_event_timed`
--
-- @number secs How many seconds to wait, approximately
-- @param[opt] leave_event If `true`, leave the event at the head of the queue
--
-- @return[0] Event, if `leave_event` is `false` or `nil` and there was no timeout
-- @return[1] `true` if `leave_event` is `true` and there was no timeout
-- @return[2] `nil` otherwise
function EventQueue:wait_timed (secs, leave_event)
	local ev = not leave_event and self.event or nil
	if al.wait_for_event_timed (self.data, ev, secs) then
		return ev or true
	-- timeout
	else
		return nil
	end
end

--------------------------------------------------------------------------------
--  Iterator
--  @section iterator
--------------------------------------------------------------------------------

local function event_iterator (queue)
	local ev = queue:get ()
	while ev do
		coroutine.yield (ev)
		ev = queue:get ()
	end
end

--- Iterator over the currently available events.
--
-- This pops and return every event until EventQueue is empty
--
-- @usage for ev in queue:available_events () do
--     -- loop body
-- end
function EventQueue:available_events ()
	return coroutine.wrap (event_iterator), self
end

return EventQueue
