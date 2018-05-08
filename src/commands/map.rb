# -*- coding: utf-8 -*-

# ==============================================================================
# * RPG Maker (VX / VX.ACE) Extender
# ------------------------------------------------------------------------------
# {{ TODO: authors }}
# ------------------------------------------------------------------------------
# Maps related commands.
#
# [Dependencies]
#   - `../*.rb`
#   - `../documentation/internal_commands.rb`
#   - `../documentation/internal_documentation.rb`
# ==============================================================================

module RME
  module Command
    module Map

      # Common parameters' declaration
      X = {:name        => :x,
           :type        => ParameterType::Coordinate,
           :description => 'Map.x'}
      Y = {:name        => :y,
           :type        => ParameterType::Coordinate,
           :description => 'Map.y'}
      LAYER = {:name => :layer,
               :type => ParameterType::PositiveInteger,
               :description => 'Map.layer'}

      # ------------------------------------------------------------------------
      # * Returns the identifier of the current map.
      # ------------------------------------------------------------------------
      Command::declare({:section     => self,
                        :name        => :map_id,
                        :description => 'Map.map_id'}) {
        $game_map.map_id
      }

      # ------------------------------------------------------------------------
      # * Returns the current map's name.
      # ------------------------------------------------------------------------
      Command::declare({:section     => self,
                        :name        => :map_name,
                        :description => 'Map.map_name'}) {
        $game_map.display_name
      }

      # ------------------------------------------------------------------------
      # * Returns the event's identifier which is located at the given
      #   coordinates (`x`, `y`).
      # ------------------------------------------------------------------------
      Command::declare({:section          => self,
                        :name             => :id_at,
                        :description      => 'Map.event_at',
                        :deprecated_since => "2.0.0",
                        :see              => [:event_at],
                        :parameters       => [X, Y]}) { |x, y| event_at(x, y) }

      # ------------------------------------------------------------------------
      # - Returns the event's identifier which is located at the given
      #   coordinates ( `x`, `y`).
      # ------------------------------------------------------------------------
      Command::declare({:section     => self,
                        :name        => :event_at,
                        :description => 'Map.event_at',
                        :parameters  => [X, Y]}) { |x, y|
        result = $game_map.event_id_xy(x, y)
        return result if result > 0
        return 0 if $game_player.x == x && $game_player.y == y
        return -1
      }

      # ------------------------------------------------------------------------
      # - Returns the type of terrain which corresponds to the tile located
      #   at the given coordinates (`x`, `y`).
      # ------------------------------------------------------------------------
      Command::declare({:section     => self,
                        :name        => :terrain_tag,
                        :description => 'Map.terrain_tag',
                        :parameters  => [X, Y]}) { |x, y|
        $game_map.terrain_tag(x, y)
      }

      # ------------------------------------------------------------------------
      # - Return the identifier of the tile located at the given coordinates
      #   (`x`, `y`, `layer`) and belonging to the given map (`map_id`).
      # ------------------------------------------------------------------------
      Command::declare({:section     => self,
                        :name        => :tile_id,
                        :description => 'Map.tile_id',
                        :parameters  => [
                          X,
                          Y,
                          LAYER,
                          {:name        => :map_id,
                           :description => 'Map.map_id',
                           :type        => ParameterType::NullablePositiveInteger,
                           :default     => nil}
                        ]}) { |x, y, layer, map_id|
        return $game_map.tile_id(x, y, layer) unless map_id
        Cache.map(map_id).data[x, y, layer]
      }

      # ------------------------------------------------------------------------
      # - Changes all the tiles which are located in the given `layer` and
      #   which are complying with the given `id` to the new `new_id`.
      # ------------------------------------------------------------------------
      Command::declare({:section     => self,
                        :name        => :set_tile_where,
                        :description => 'Map.set_tile_where',
                        :parameters  => [
                          LAYER,
                          {:name        => :id,
                           :description => 'Map.set_tile_where.id',
                           :type        => ParameterType::PositiveInteger},
                          {:name        => :new_id,
                           :description => 'Map.set_tile_where.new_id',
                           :type        => ParamaterType::PositiveInteger}
                        ]}) { |layer, id, new_id|
        map = $game_map.instance_variable_get(:@map)
        map_height.times do |y|
          map_width.times do |x|
            map.data[x, y, layer] = new_id if map.data[x, y, layer] == id
          end
        end
      }

      # ------------------------------------------------------------------------
      # - Deletes all the tiles which are located in the given `layer` and
      #   complying with the given `id`.
      # ------------------------------------------------------------------------
      Command::declare({:section     => self,
                        :name        => :delete_tiles,
                        :description => 'Map.delete_tiles',
                        :parameters  => [
                          LAYER,
                          {:name        => :id,
                           :description => 'Map.delete_tiles.id',
                           :type        => ParameterType::PositiveInteger}
                        ]}) { |layer, id|
        set_tile_where(layer, id, 0)
      }

      # ------------------------------------------------------------------------
      # - Changes the tile which is located at the given coordinates
      #   (`x`, `y`, `layer`), with the new `value`.
      # ------------------------------------------------------------------------
      Command::declare({:section     => self,
                        :name        => :set_tile,
                        :description => 'Map.set_tile',
                        :parameters  => [
                          {:name        => :value,
                           :description => 'Map.set_tile.value',
                           :type        => ParameterType::PositiveInteger},
                          X,
                          Y,
                          LAYER
                        ]}) { |value, x, y, layer|
        $game_map.instance_variable_get(:@map).data[x, y, layer] = value
      }

      # ------------------------------------------------------------------------
      # - Returns the region's identifier to which the tile located at the
      #   given coordinates belongs to (`x`, `y`).
      # ------------------------------------------------------------------------
      Command::declare({:section     => self,
                        :name        => :region_id,
                        :description => 'Map.region_id',
                        :parameters  => [X, Y]}) { |x, y|
        $game_map.region_id(x, y)
      }

      # ------------------------------------------------------------------------
      # - Checks if the tile located at the given coordinates (`x`, `y`)
      #   can be passed through in the given `direction`.
      # ------------------------------------------------------------------------
      Command::declare({:section     => self,
                        :name        => :square_passable?,
                        :description => 'Map.square_passable?',
                        :parameters  => [
                          X,
                          Y,
                          {:name        => :direction,
                           :description => 'Map.direction',
                           :type        => ParameterType::Direction,
                           :default     => 2}
                        ]}) { |x, y, direction|
        $game_map.passable?(x, y, d)
      }

      # ------------------------------------------------------------------------
      # - Returns the identifier of the main tileset used to render
      #   the current map.
      # ------------------------------------------------------------------------
      Command::declare({:section     => self,
                        :name        => :get_tileset_id,
                        :description => 'Map.get_tileset_id'}) {
        $game_map.tileset_id
      }

      # ------------------------------------------------------------------------
      # - Tells whether the dash is enabled (`true`) or not (`false`)
      #   for the player in the current map.
      # ------------------------------------------------------------------------
      Command::declare({:section     => self,
                        :name        => :dash_activate?,
                        :description => 'Map.dash_activate?'}) {
        $game_map.can_dash
      }

      # ------------------------------------------------------------------------
      # - Tells whether the dash is disabled (`true`) or not (`false`)
      #   for the player in the current map.
      # ------------------------------------------------------------------------
      Command::declare({:section     => self,
                        :name        => :dash_deactivate?,
                        :description => 'Map.dash_deactivate?'}) {
        !dash_activate?
      }

      # ------------------------------------------------------------------------
      # - Enables (`true`) or disables (`false`) the dashing option for the
      #   player in the current map.
      # ------------------------------------------------------------------------
      Command::declare({:section     => self,
                        :name        => :dash_activation,
                        :description => 'Map.dash_activation',
                        :parameters  => [
                          {:name        => :flag,
                           :description => 'Map.dash_activation.flag',
                           :type        => ParameterType::Boolean}]}) {
        |flag|
        $game_map.can_dash = !!flag
      }

      # ------------------------------------------------------------------------
      # - Enables the dashing option for the player in the current map.
      # ------------------------------------------------------------------------
      Command::declare({:section     => self,
                        :name        => :dash_activate,
                        :description => 'Map.dash_activate'}) {
        dash_activation(true)
      }

      # TODO
      # - `switch_tileset`
      # - `wall?`
      # - `roof?`
      # - `stair?`
      # - `table?`
      # - `map_width`
      # - `map_height`
      # - `ground?`
      # - `boat_passable?`
      # - `ship_passable?`
      # - `autotile_type`
      # - `damage_floor?`
      # - `get_random_square`
      # - `get_squares_by_region`
      # - `get_squares_by_tile`
      # - `get_squares_by_terrain`

    end
  end
end