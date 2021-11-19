classdef PE_Unit < handle
    properties
        output;                 % Output of an operation
        addBuffer;              % Buffer to hold the addition operand
        filterCoefficient;      % Filter coefficient used in multiplication
        inputFeature;           % Input value used in multiplication
    end

    methods
        function obj = PE_Unit()
            % Object constructor the a PE unit. Sets all values to zero
            % initially.
            obj.output = 0;
            obj.addBuffer = 0;
            obj.filterCoefficient = 0;
            obj.inputFeature = 0;
        end

        function output = MAC(obj)
            % Calculate the output with the MAC operation. Note that
            % filterCoeffiient, inputFeature, and addBuffer need to be set
            % before calling this function.
            obj.output = obj.filterCoefficient*obj.inputFeature + obj.addBuffer;
            output = obj.output;
        end
    end
end