#
# @file functional_arrays.js
# Contains modifications to the prototypical Array to facilitate functional programming.
#
# Copyright (C) 2011 Thomas P. Lahoda
#
# This library is free software; you can redistribute it and/or
# modify it under the terms of the GNU Lesser General Public
# License as published by the Free Software Foundation; either
# version 2.1 of the License, or (at your option) any later version.
#
# This library is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
# Lesser General Public License for more details.

# You should have received a copy of the GNU Lesser General Public
# License along with this library; if not, write to the Free Software
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301  USA
#

# Makes a copy of the arguments from begin to end.
#
# @param begin The begining of the range.
# @param end The end of the range.
# @param args The arguments.
#
# @return The remaining arguments.
#
Array.prototype.slice_args = (args, begin, end) ->
  Array.prototype.slice.call args, begin, end

# Applies action to all of the elements of the Array.
#
# @param action The action to apply.
#
# @return The Array.
#
Array.prototype.apply = (action) ->
  args = Array.prototype.slice_args arguments
  args.unshift this.length
  args.unshift 0
  this.apply_range.apply this, args

# Applies action to the specified range of the Array elements.
#
# @param begin The beginning of the range.
# @param end The end of the range.
# @param action The action to apply.
#
# @return The Array.
#
Array.prototype.apply_range = (begin, end, action) ->
  args = Array.prototype.slice_args arguments, 3
  for i in [begin...end]
    args.unshift this[i]
    this[i] = action.apply null, args
    args.shift()
  this

# Applies action to the specified indices of the Array elements.
#
# @param The indices to which to apply the action.
# @param action The action to apply.
#
# @return The Array.
#
Array.prototype.apply_index = (indices, action) ->
  args = Array.prototype.slice_args arguments, 2
  for i in indices
    args.unshift this[i]
    this[i] = action.apply null, args
    args.shift()
  this

# Runs action for all of the elements of the Array.
#
# @param action The action to apply.
#
# @return The Array.
#
Array.prototype.for_each = (action) ->
  args = Array.prototype.slice_args arguments
  args.unshift this.length
  args.unshift 0
  this.for_each_range.apply this, args

# Runs action on each element in the specified range of the Array.
#
# @param begin The beginning of the range.
# @param end The end of the range.
# @param action The action to apply.
#
# @return The Array.
#
Array.prototype.for_each_range = (begin, end, action) ->
  args = Array.prototype.slice_args arguments, 3
  for i in [begin...end]
    args.unshift this[i]
    res = action.apply null, args
    if typeof res != 'undefined' and !res
      break
    args.shift()
  this

# Runs action on each of the indices of the Array.
#
# @param indices The indices on which to run the action.
# @param action The action to apply.
#
# @return The Array.
#
Array.prototype.for_each_index = (indices, action) ->
  args = Array.prototype.slice_args arguments, 2
  for i in indices
    args.unshift this[i]
    res = action.apply null, args
    if typeof res != 'undefined' and !res
      break
    args.shift()
  this
