
--[[
  THIS SCRIPT CONTAINS AN IMPLEMENTATION OF THE 8-QUEENS PROBLEM IN LUA
  OUTPUTS A TABLE CONTAINING THE MOST FIT SOLUTION WHERE EACH ELEMENT REPRESENTS
  THE POSITION OF A QUEEN IN A COLUMN

  THIS ALGORITHM DOESN'T USE AN ELITIST APPROACH, I.E., THE SELECTION OF PARENTS
  DOESN'T TAKE INTO ACCOUNT THE FITNESS OF THE POPULATION'S INDIVIDUALS
]]

require 'population'


local function fitnessFunction(individual)
  local verticalCollisions = 0
  local diagonalCollisions = 0

  for i,target in ipairs(individual) do
    for j,queen in ipairs(individual) do
      --queens in the same row that aren't the same queen
      if target == queen and i ~= j then
        print(i,j)
        verticalCollisions = verticalCollisions + 1
      --checking for queens in the same diagonal
      else
        local mod = i-j
        if mod < 0 then
          if queen + mod == target or queen - mod == target then
            diagonalCollisions = diagonalCollisions + 1
          end
        end
      end
    end
  end
  print(verticalCollisions)
  print(diagonalCollisions)
  return 28-(verticalCollisions/2 + math.ceil(diagonalCollisions/2))
end

function geneticAlgorithm(population, fitnessFunction)

  local goodFit = false
  while not goodFit do
    for k,v in ipairs(population) do

    end
  end
end

local population = Population.new(10)
population:generate()
print(population:getPopulation()[4])
--geneticAlgorithm(population,fitnessFunction)
local a = fitnessFunction(population:getPopulation()[4])

print(a)
