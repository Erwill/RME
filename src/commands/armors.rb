# -*- coding: utf-8 -*-

# ==============================================================================
# * RPG Maker (VX / VX.ACE) Extender
# ------------------------------------------------------------------------------
# {{ TODO: authors }}
# ------------------------------------------------------------------------------
# Armors related commands.
#
# [Dependencies]
#   - `../*.rb`
#   - `../documentation/internal_commands.rb`
#   - `../documentation/internal_documentation.rb`
# ==============================================================================

module RME
  module Command
    module Armors

      # Common parameters' declaration
      ARMOR_ID = {:name        => :id,
                  :type        => ParameterType::ItemId,
                  :description => 'Armors.armor_id'}

      # ------------------------------------------------------------------------
      # * Returns the list of armors that are currently owned by the player.
      # ------------------------------------------------------------------------
      Command::declare({:section     => self,
                        :name        => :armors_possessed,
                        :description => 'Armors.armors_possessed'}) do
        $game_party.armors.map {|i| [i.id] * $game_party.item_number(i)}.flatten
      end

      # ------------------------------------------------------------------------
      # * Counts the number of copies for the given armor, that are currently
      #   owned by the player.
      # ------------------------------------------------------------------------
      Command::declare({:section     => self,
                        :name        => :armor_count,
                        :description => 'Armors.armor_count',
                        :parameters  => [
                          {:name        => :id,
                           :description => 'Armors.armor_count.id',
                           :type        => ParameterType::ItemId}
                        ]}) do |id|
        $game_party.item_number($data_armors[id])
      end

      # ------------------------------------------------------------------------
      # * Returns the name of the given armor.
      # ------------------------------------------------------------------------
      Command::declare({:section     => self,
                        :name        => :armor_name,
                        :description => 'Armors.armor_name',
                        :parameters  => [ARMOR_ID]}) do |id|
        $data_armors[id].name
      end

      # ------------------------------------------------------------------------
      # * Returns the note attached to the given armor.
      # ------------------------------------------------------------------------
      Command::declare({:section     => self,
                        :name        => :armor_note,
                        :description => 'Armors.armor_note',
                        :parameters  => [ARMOR_ID]}) do |id|
        $data_armors[id].note
      end

      # ------------------------------------------------------------------------
      # * Returns the given armor's description.
      # ------------------------------------------------------------------------
      Command::declare({:section     => self,
                        :name        => :armor_description,
                        :description => 'Armors.armor_description',
                        :parameters  => [ARMOR_ID]}) do |id|
        $data_armors[id].description
      end

      # ------------------------------------------------------------------------
      # * Returns the given armor's icon's index, within the current iconset.
      # ------------------------------------------------------------------------
      Command::declare({:section     => self,
                        :name        => :armor_icon,
                        :description => 'Armors.armor_icon',
                        :parameters  => [ARMOR_ID]}) do |id|
        $data_armors[id].icon_index
      end

      # ------------------------------------------------------------------------
      # * Returns the price of the given armor.
      # ------------------------------------------------------------------------
      Command::declare({:section     => self,
                        :name        => :armor_price,
                        :description => 'Armors.armor_price',
                        :parameters  => [ARMOR_ID]}) do |id|
        $data_armors[id].price
      end

      # ------------------------------------------------------------------------
      # * Returns the additional health points that this armor gives when
      #   equipped.
      # ------------------------------------------------------------------------
      Command::declare({:section     => self,
                        :name        => :armor_max_hit_points,
                        :description => 'Armors.armor_max_hit_points',
                        :parameters  => [ARMOR_ID]}) do |id|
        $data_armors[id].params[0]
      end

      # ------------------------------------------------------------------------
      # * Returns the additional magic points that this armor gives when
      #   equipped.
      # ------------------------------------------------------------------------
      Command::declare({:section     => self,
                        :name        => :armor_max_magic_points,
                        :description => 'Armors.armor_max_magic_points',
                        :parameters  => [ARMOR_ID]}) do |id|
        $data_armors[id].params[1]
      end

      # ------------------------------------------------------------------------
      # * Returns the attack power that this armor gives when equipped.
      # ------------------------------------------------------------------------
      Command::declare({:section     => self,
                        :name        => :armor_attack_power,
                        :description => 'Armors.armor_attack_power',
                        :parameters  => [ARMOR_ID]}) do |id|
        $data_armors[id].params[2]
      end

      # ------------------------------------------------------------------------
      # * Returns the defense power that this armor gives when equipped.
      # ------------------------------------------------------------------------
      Command::declare({:section     => self,
                        :name        => :armor_defense_power,
                        :description => 'Armors.armor_defense_power',
                        :parameters  => [ARMOR_ID]}) do |id|
        $data_armors[id].params[3]
      end

      # ------------------------------------------------------------------------
      # * Returns the magical attack power that this armor gives when equipped.
      # ------------------------------------------------------------------------
      Command::declare({:section     => self,
                        :name        => :armor_magic_attack_power,
                        :description => 'Armors.armor_magic_attack_power',
                        :parameters  => [ARMOR_ID]}) do |id|
        $data_armors[id].params[4]
      end

      # ------------------------------------------------------------------------
      # * Returns the magical defense power that this armor gives when equipped.
      # ------------------------------------------------------------------------
      Command::declare({:section     => self,
                        :name        => :armor_magic_defense_power,
                        :description => 'Armors.armor_magic_defense_power',
                        :parameters  => [ARMOR_ID]}) do |id|
        $data_armors[id].params[5]
      end

      # ------------------------------------------------------------------------
      # * Returns the agility points that this armor gives when equipped.
      # ------------------------------------------------------------------------
      Command::declare({:section     => self,
                        :name        => :armor_agility,
                        :description => 'Armors.armor_agility',
                        :parameters  => [ARMOR_ID]}) do |id|
        $data_armors[id].params[6]
      end

      # ------------------------------------------------------------------------
      # * Returns the luck points that this armor gives when equipped.
      # ------------------------------------------------------------------------
      Command::declare({:section     => self,
                        :name        => :armor_luck,
                        :description => 'Armors.armor_luck',
                        :parameters  => [ARMOR_ID]}) do |id|
        $data_armors[id].params[7]
      end

      # ------------------------------------------------------------------------
      # * Gives or removes copies of the given armor from the player's
      #   inventory.
      # ------------------------------------------------------------------------
      Command::declare({:section     => self,
                        :name        => :give_armor,
                        :description => 'Armors.give_armor',
                        :parameters  => [
                          ARMOR_ID,
                          {:name        => :amount,
                           :description => 'Armors.give_armor.amount',
                           :type        => ParameterType::Integer
                          },
                          {:name        => :include_equipment,
                           :description => 'Armors.give_armor.include_equipment',
                           :type        => ParameterType::Boolean,
                           :default     => false}
                        ]}) do |id, amount, include_equipment|
        item = $data_armors[id];
        $game_party.gain_item(item, amount, include_equipment)
      end

      # ------------------------------------------------------------------------
      # * Tells wether the player owns the given armor (`true`);
      #   or not (`false`).
      # ------------------------------------------------------------------------
      Command::declare({:section     => self,
                        :name        => :has_armor?,
                        :description => 'Armors.has_armor?',
                        :parameters  => [
                          ARMOR_ID,
                          {:name        => :include_equipment,
                           :description => 'Armors.has_armor?.include_equipment',
                           :type        => ParameterType::Boolean,
                           :default     => false}
                        ]}) do |id, include_equipment|
        item = $data_armors[id]
        $game_party.has_item?(item, include_equipment)
      end

      # ------------------------------------------------------------------------
      # * Tells wether the given actor owns the given armor (`true`);
      #   or not (`false`).
      # ------------------------------------------------------------------------
      Command::declare({:section     => self,
                        :name        => :armor_equipped?,
                        :description => 'Armors.armor_equiped?',
                        :parameters  => [
                          ARMOR_ID,
                          {:name        => :member_id,
                           :description => 'Armors.armor_equiped?.member_id',
                           :type        => ParameterType::PositiveInteger,
                           :default     => nil}
                        ]}) do |id, member_id|
        item = $data_armors[id]
        unless member_id
          $game_party.members_equip_include?(item)
        else
          $game_actors[member_id].equips.include?(item)
        end
      end

      # ------------------------------------------------------------------------
      # * Returns the given armor's type.
      # ------------------------------------------------------------------------
      Command::declare({:section     => self,
                        :name        => :armor_type,
                        :description => 'Armors.armor_type',
                        :parameters  => [ARMOR_ID]}) do |id|
        i = $data_armors[id].atype_id
        $data_system.armor_types[i]
      end

      append_commands
    end
  end
end