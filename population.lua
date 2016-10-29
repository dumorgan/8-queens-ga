--[[
  THIS SCRIPT CONTAINS A CLASS THAT REPRESENTS A POPULATION OF QUEENS
  IN A CHESSBOARD
]]

require 'math'

Population = {}

Population.__index = Population


function Population.new(popSize)
  local self = setmetatable({}, Population)
  self.popSize = popSize
  self.boardSize = 8
  self.populationList = {}
  return self
end

function Population.generate(self)
  for i=1,self.popSize do
    local individual = {}
    for j=1,8 do
      table.insert(individual,math.random(1,8))
    end
    table.insert(self.populationList,individual)
  end
end

function Population.getPopulation(self)
  return self.populationList
end
