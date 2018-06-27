# -*- coding: utf-8 -*-

# ==============================================================================
# * RPG Maker (VX / VX.ACE) Extender
# ------------------------------------------------------------------------------
# {{ TODO: authors }}
# ------------------------------------------------------------------------------
# Commands which manages the camera (map's scrolling for instance)
#
# [Dependencies]
#   - `../*.rb`
#   - `../documentation/internal_commands.rb`
#   - `../documentation/internal_documentation.rb`
# ==============================================================================

module RME
  module Command
    module Camera

      # Common parameters' declaration
      DISTANCE = {:name        => :distance,
                  :type        => ParameterType::PositiveInteger,
                  :description => 'Camera.distance'}

      # ------------------------------------------------------------------------
      # * Tells whether the camera is currently scrolling (`true`);
      #   or not (`false`)
      # ------------------------------------------------------------------------
      Command::declare({:section     => self,
                        :name        => :camera_scrolling?,
                        :description => 'Camera.camera_scrolling?'}) do
        $game_map.scrolling? || $game_map.scrolling_activate
      end

      # ------------------------------------------------------------------------
      # * Scrolls the camera in the given `direction`.
      # ------------------------------------------------------------------------
      Command::declare({:section     => self,
                        :name        => :camera_scroll,
                        :description => 'Camera.camera_scroll',
                        :parameters  => [
                          {:name        => :direction,
                           :type        => ParameterType::Direction,
                           :description => 'Camera.camera_scroll.direction'},
                          DISTANCE,
                          {:name        => :speed,
                           :type        => ParameterType::PositiveFloat,
                           :description => 'Camera.camera_scroll.speed'}
                        ]}) do |direction, distance, speed|
        Fiber.yield while $game_map.scrolling?
        $game_map.start_scroll(direction, distance, speed)
      end

      # TODO
      # - `camera_scroll_towards`
      # - `camera_scroll_towards_event`
      # - `camera_scroll_towards_player`
      # - `camera_move_on`
      # - `camera_scroll_on`
      # - `camera_lock`
      # - `camera_unlock`
      # - `camera_locked?`
      # - `camera_lock_x`
      # - `camera_unlock_x`
      # - `camera_x_locked?`
      # - `camera_lock_y`
      # - `camera_unlock_y`
      # - `camera_y_locked?`
      # - `camera_change_focus`
      # - `camera_zoom`
      # - `camera_motion_blur`

      append_commands
    end
  end
end