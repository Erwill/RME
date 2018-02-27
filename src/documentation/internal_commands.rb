# -*- codintg: utf-8 -*-

# ==============================================================================
# * RPG Maker (VX / VX.ACE) Extender
# ------------------------------------------------------------------------------
# Internal definition of how to declare a command.
# ==============================================================================
module RME

  module Command

    # ==========================================================================
    # ** Enumeration of commands' parameters' types.
    # ==========================================================================
    module ParameterType

      # ========================================================================
      # * Domain of definition of one type.
      #   (That is to say the set of valid values for one type)
      # ========================================================================
      class Domain
        attr_reader :predicate

        # ----------------------------------------------------------------------
        # * Initializes this domain with the given `predicate`.
        # ----------------------------------------------------------------------
        def initialize(predicate)
          @predicate = predicate
        end

        # ----------------------------------------------------------------------
        # * Tells whether the given value (`val`) belongs to this domain or not.
        # -> `true` if the value belongs to this domain;
        #    `false` otherwise.
        # ----------------------------------------------------------------------
        def valid?(val)
          predicate.call val
        end
      end

      # ========================================================================
      # * Enumeration of distinct values (peculiar domain).
      # ========================================================================
      class Set
        attr_reader :elements

        # ----------------------------------------------------------------------
        # * Initializes this set with the given `elements`.
        # ----------------------------------------------------------------------
        def initialize(*elements)
          @elements = elements
        end

        # ----------------------------------------------------------------------
        # * Tells whether the given value (`val`) belongs to this set or not.
        # -> `true` if the value belongs to this set;
        #    `false` otherwise.
        # ----------------------------------------------------------------------
        def valid?(val)
          @elements.include? val
        end

      end

      # Sets are also known as enumerations
      Enum = Set

      # ========================================================================
      # * Closed interval: [`min`, `max`] (peculiar domain).
      # ========================================================================
      class ClosedInterval
        attr_reader :range

        # ----------------------------------------------------------------------
        # * Initializes this closed interval: [`min`, `max`].
        # ----------------------------------------------------------------------
        def initialize(min, max)
          @range = (min..max)
        end

        # ----------------------------------------------------------------------
        # * Tells whether the given value (`val`) is contained within this
        #   interval.
        # -> `true` if the value belongs to this interval;
        #    `false` otherwise.
        # ----------------------------------------------------------------------
        def valid?(val)
          @range.include? val
        end
      end

      # Domain's constructor
      # [! This constructor should not be used: instead use `::declare` !]
      Constructor = Struct.new(:name, :internal_description, :domain)

      # ------------------------------------------------------------------------
      # * Registers a new type of command's parameter under `ParameterType`.
      #   - `name` the type's name                                 Symbol/String
      #   - `internal_description` the type's description                 String
      #     for developers only (not the one documented)
      #   - `domain` the type's domain of definition                      Domain
      # ------------------------------------------------------------------------
      def self.declare(name, internal_description, domain)
        type = Constructor.new(name, internal_description, domain)
        self.const_set(name, type)
      end

      # Common domains' definitions
      ParameterType::declare(:Coordinate,
                             "Coordinate of a point in a cartesian coordinate system (i.e.: `x` or `y`)",
                             ClosedInterval.new(0, 999))
      ParameterType::declare(:Boolean,
                             "Boolean value",
                             Set.new(true, false))
      ParameterType::declare(:PositiveInteger,
                             "Positive integer",
                             Domain.new(lambda { |x| (x.is_a? Integer) and (0 <= x) }))

      # TODO: add other domains' definition

    end


    # ----------------------------------------------------------------------
    # * Declares a new RME Command.
    # ----------------------------------------------------------------------
    def self.declare(cmd)
      # Documenting method
      # TODO

      # Selecting namespace under which the command will be declared
      namespace =
        if cmd[:namespace].is_a? Module
          cmd[:namespace]
        else
          self
        end

      # Generating method
      namespace.define_singleton_method(cmd[:name]) do |*args|

        # Validating each parameter
        cmd[:parameters].each_with_index do |expected, i |

          # Handling optional parameter
          unless expected[:default].nil?
            if args[i].nil?
              args << expected[:default]
            end
          end

          # Validating provided parameter
          unless expected[:type][:domain].valid? args[i]
            arg_value = (args[i].nil?) ? "nil (i.e.: not provided)." : args[i]
            raise "Invalid parameter: #{expected[:name]} " +
                  "(should be a #{expected[:type][:internal_description]}). " +
                  "Actual value is #{arg_value}"
          end

        end

        # Calling the delegated method
        if (cmd[:call].is_a? Proc)
          cmd[:call]
        elsif block_given?
          yield args
        else
          raise "There is no underlying block or method to call for #{cmd[:name]} !"
        end

      end
    end

  end

end