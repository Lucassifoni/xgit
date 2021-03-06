# Copyright (C) 2016, Google Inc.
# and other copyright owners as documented in the project's IP log.
#
# Elixir adaptation from jgit file:
# org.eclipse.jgit/src/org/eclipse/jgit/util/time/ProposedTimestamp.java
#
# Copyright (C) 2019, Eric Scouten <eric+xgit@scouten.com>
#
# This program and the accompanying materials are made available
# under the terms of the Eclipse Distribution License v1.0 which
# accompanies this distribution, is reproduced below, and is
# available at http://www.eclipse.org/org/documents/edl-v10.php
#
# All rights reserved.
#
# Redistribution and use in source and binary forms, with or
# without modification, are permitted provided that the following
# conditions are met:
#
# - Redistributions of source code must retain the above copyright
#   notice, this list of conditions and the following disclaimer.
#
# - Redistributions in binary form must reproduce the above
#   copyright notice, this list of conditions and the following
#   disclaimer in the documentation and/or other materials provided
#   with the distribution.
#
# - Neither the name of the Eclipse Foundation, Inc. nor the
#   names of its contributors may be used to endorse or promote
#   products derived from this software without specific prior
#   written permission.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND
# CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES,
# INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES
# OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
# ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR
# CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
# SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT
# NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
# LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
# CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
# STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
# ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF
# ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

defmodule Xgit.Util.Time.ProposedTimestamp do
  @moduledoc ~S"""
  A timestamp generated by `MonotonicClock`.

  PORTING NOTE: For now, we are not implementing network protocols related to
  time, but implementing just enough of the abstraction to allow that to be
  implemented later.

  The ability to block until the timestamp has passed is not yet implemented.
  """

  defprotocol Impl do
    @moduledoc ~S"""
    An implementation strategy for `ProposedTimestamp`.

    We mostly use this for testing to replace actual delays with mimiced delays.
    """

    @doc ~S"""
    Get time since epoch in microseconds.

    This is typically the same as
    [`System.os_time(:microsecond)`](https://hexdocs.pm/elixir/System.html#os_time/1).
    """
    @spec read(timestamp :: term) :: integer
    def read(timestamp)
  end

  @doc ~S"""
  Read the timestamp as `unit` since the epoch.

  Units are as defined by the
  [`System.time_unit` type](https://hexdocs.pm/elixir/System.html#t:time_unit/0),
  except that `:nanosecond` is not supported.
  """
  def read(timestamp, :microsecond), do: read(timestamp, 1)
  def read(timestamp, :millisecond), do: read(timestamp, 1000)
  def read(timestamp, :second), do: read(timestamp, 1_000_000)

  def read(timestamp, unit) when is_integer(unit) and unit > 0 do
    timestamp
    |> __MODULE__.Impl.read()
    |> Kernel.div(unit)
  end
end
