
--[[
  THIS SCRIPT CONTAINS AN IMPLEMENTATION OF THE 8-QUEENS PROBLEM IN LUA
  OUTPUTS A TABLE CONTAINING THE MOST FIT SOLUTION WHERE EACH ELEMENT REPRESENTS
  THE POSITION OF A QUEEN IN A COLUMN

  THIS ALGORITHM USES AN ELITIST APPROACH I.E. ONLY A RATE OF BEST FIT INDIVIDUALS
  ARE CHOSEN TO REPRODUCE. ALSO ALL THE INDIVIDUALS ARE KILLED IN THE PROCESS
]]

--Defining the global variables for the problem
local boardSize = 8
local populationSize = 10
local mutationRate = 0.03
local reproductionRate = 0.5

--[[
  DEFINITION OF A POPULATION CLASS
]]
Population = {}

Population.__index = Population

--constructor
function Population.new(popSize)
  local self = setmetatable({}, Population)
  self.popSize = popSize
  self.boardSize = 8
  self.populationList = {}
  self.fitnessList = {}
  return self
end

--generates the first batch of individuals
function Population.generate(self)
  for i=1,self.popSize do
    local individual = {}
    for j=1,8 do
      table.insert(individual,math.random(1,8))
    end
    table.insert(self.populationList,individual)
  end
end

--gets current population list
function Population.getPopulation(self)
  return self.populationList
end

--sets population list
function Population.setPopulation(self,offspring)
  self.populationList = offspring
end

--computes a list of individual's fitness
--each entry contains the index of the individual in the populationList and its fitness
function Population.computeFitnessList(self)
  self.fitnessList = {}
  for k,individual in ipairs(self.populationList) do
    local fitness = fitnessFunction(individual)
    table.insert(self.fitnessList,{individual = k, fitness = fitness})
  end
  table.sort(self.fitnessList, function(a,b) return a.fitness > b.fitness end)
end

--gets the fitness list
function Population.getFitnessList(self)
  return self.fitnessList
end

--computes the fitness of an individual
function fitnessFunction(individual)
  local verticalCollisions = 0
  local diagonalCollisions = 0

  for i,target in ipairs(individual) do
    for j,queen in ipairs(individual) do
      --queens in the same row that aren't the same queen
      if target == queen and i ~= j then
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
  return 28-(verticalCollisions/2 + math.ceil(diagonalCollisions/2))
end

--randomly selects two parents
--only the reproductionRate best parents can be chosen
local function randomSelect(populationList, fitnessList)
  local amountOfParents = reproductionRate*(#fitnessList)
  local indexParent1 = math.random(1,amountOfParents)
  local indexParent2 = indexParent1
  while indexParent2 == indexParent1 do
    indexParent2 = math.random(1,amountOfParents)
  end
  local parent1 = populationList[fitnessList[indexParent1].individual]
  local parent2 = populationList[fitnessList[indexParent2].individual]

  return parent1, parent2
end

--does crossover between two parents
local function crossover(parent1,parent2)
  local crossoverRate = math.random(boardSize)
  local child = {}

  for i=1,crossoverRate do
    table.insert(child,parent1[i])
  end
  for j=crossoverRate+1,#parent2 do
    table.insert(child,parent2[j])
  end
  return child
end

--mutates a child
local function mutate(child)
  if math.random(0,100) <= 100*mutationRate then
    local mutatedGene = math.random(1,8)
    local oldGene = child[mutatedGene]
    while child[mutatedGene] == oldGene do
      child[mutatedGene] = math.random(1,8)
    end
  end
  return child
end

--reproduction function, gets the populationList and the fitnessList
--returns the child
local function reproduce(populationList, fitnessList)
  local parent1, parent2 = randomSelect(populationList, fitnessList)
  local child = crossover(parent1,parent2)
  child = mutate(child)
  return child
end

--this is the core function
--gets the first batch of individuals and makes calls to all the functions
--the algorithm stops when best possible fitness (28) is achieved or 1000 iterations have happened
local function geneticAlgorithm(population)
  local generations = 0
  local currentBestFitness = 0
  population:generate()
  population:computeFitnessList()
  local goodFit = false
  while not goodFit do

    generations = generations + 1
    local fitnessList = population:getFitnessList()
    local offspring = {}

    for i=1,populationSize do
      local child = reproduce(population:getPopulation(), fitnessList)
      table.insert(offspring,child)
    end

    population:setPopulation(offspring)
    population:computeFitnessList()
    local newFitnessList = population:getFitnessList()
    currentBestFitness = newFitnessList[1].fitness
    if currentBestFitness == 28 or generations >= 1000 then
      goodFit = true
    end

  end
  local bestFit = population:getPopulation()[population:getFitnessList()[1].individual]
  return bestFit, generations, currentBestFitness
end


--Main part, instantiates a new population and calls the geneticAlgorithm function
math.randomseed(os.time())
local population = Population.new(populationSize)
local bestFit, generations, currentBestFitness = geneticAlgorithm(population)
print("Best fit individual: ("..table.concat(bestFit,',')..")")
print("Number of collisions "..(28-currentBestFitness))
print("Number of iterations: "..generations)
