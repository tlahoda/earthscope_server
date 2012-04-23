#
# @file coordinate_transforms.js
# Contains coordinate transform functions.
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
#
# You should have received a copy of the GNU Lesser General Public
# License along with this library; if not, write to the Free Software
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301  USA
#

# Precalculated pi / 2.
#
Math.piOverTwo = Math.PI / 2.0;

# Precalculated deg2rad conversion factor.
#
Math.deg2rad = Math.PI / 180.0;

# Converts a lat/lon point to a two dimensional point in an orthographic projection.
#
# @param point The lat/lon point.
#
# @return The two dimensional point.
#
@toOrtho= (point) ->
  point[0] *= Math.deg2rad
  point[1] *= Math.deg2rad
  slat = Math.sin Math.piOverTwo - point[0]
  [slat * Math.cos(point[1]), slat * Math.sin(point[1])]

@toWebGL= (point) ->
  point[0] *= Math.deg2rad
  point[1] *= Math.deg2rad
  clat = Math.cos point[0]
  [clat * Math.cos(point[1]), Math.sin(point[0]), -(clat * Math.sin(point[1]))]

@scale= (vertex, s, axis) ->
  if !axis
    return vertex.apply (ele, s) ->
      ele * s
    , s
  vertex[axis] *= s
  vertex

@shift= (vertex, s, axis) ->
  if !axis
    return vertex.apply (ele, s) ->
      ele + s
    , s
  vertex[axis] += s
  vertex

@invert= (vertex, bound, axis) ->
  if !axis
    return vertex.apply (ele, bound) ->
      bound - ele
    , bound
  vertex[axis] = bound - vertex[axis]
  vertex

return
