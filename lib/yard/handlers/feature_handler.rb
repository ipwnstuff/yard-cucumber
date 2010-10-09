module YARD
  module Handlers
    module Cucumber

      class FeatureHandler < Base

        handles CodeObjects::Cucumber::Feature

        def process 
                    
          # For the background and the scenario, find the steps that have definitions
          process_scenario(statement.background) if statement.background
          
          statement.scenarios.each do |scenario|
            process_scenario(scenario)
          end
          
        rescue YARD::Handlers::NamespaceMissingError
        end
        
        
        def process_scenario(scenario)
          scenario.steps.each do |step|
            owner.step_definitions.each do |stepdef|
              if %r{#{stepdef.compare_value}}.match(step.value)
                step.definition = stepdef
                stepdef.steps << step
                log.info "STEP #{step} has found its definition #{stepdef}"
                break
              end
            end
          end
            
        end
        

      end

    end
  end
end