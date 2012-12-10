--[[
Crafts an item with ingredients.

ingredients is an array of numbers.
  It is what slots have ingredients.
  There is a limit of 7.
recipe is an 9 long array of numbers.
  Each is an index of ingredients.
chest is a number.
  It is a slot containing 2+ chests.
output is a number.
  It is the output slot.
  It must be empty.
]]--

function shaped_crafting(ingredients,
                         recipe,
                         chest,
                         copies,
                         output)
invsize = 16
gridsize = 9
crafting = {1, 2, 3,
            5, 6, 7,
  		9, 10, 11}
holding = {4, 8, 12, 16, 15, 14, 13}
limit = table.getn(holding)
count = table.getn(ingredients)

--[[ Check ingredients validity. ]]--
for x = 1, count do
  if ingredients[x] > 16 then
    print("Invalid ingredient.")
	return
  end
end
--[[ Check recipe validity. ]]--
for x = 1, table.getn(recipe) do
  if recipe[x] > count then
    print("Invalid recipe.")
	return
  end
end
--[[ Check ingredient types <= 7. ]]--
if count > limit then
  print("Too many ingredients.")
  return
end
--[[ Check for 2+ chests. ]]--
if turtle.getItemCount(chest) < 2 then
  print("Not enough chests.")
  return
end
--[[ Check ingredients quantity. ]]--
--[[ Check output slot is empty. ]]--
if turtle.getItemCount(output) > 0
then
  print("Output slot has an item.")
  return
end
--[[ Place chests B and A. ]]--
turtle.select(chest)
turtle.turnLeft()
turtle.dig()
turtle.place()
turtle.turnRight()
turtle.turnRight()
turtle.dig()
turtle.place()
--[[ Deposit non ingredients into A.
Make sure to do this in order. ]]--
for x = 1, invsize do
  dropme = true
  for y = 1, count do
    if ingredients[y] == x then
	  dropme = false
	end
  end
  if dropme then
    turtle.select(x)
    turtle.drop()
  end
end
--[[ Deposit ingredients into B. ]]--
turtle.turnLeft()
turtle.turnLeft()
for x = 1, invsize do
  turtle.select(x)
  turtle.drop()
end
--[[ Suck up ingredients into the area
outside of the crafting grid. ]]--
for x = 1, limit do
  turtle.select(holding[x])
  turtle.suck()
end
--[[ Move the ingredients into the
crafting pattern. ]]--
for x = 1, 9 do
  if recipe[x] > 0 then
	turtle.select(holding[recipe[x]])
    turtle.transferTo(crafting[x],
	copies)
  end
end
--[[ Place surplus back into B. ]]--
for x = 1, limit do
  turtle.select(holding[x])
  turtle.drop()
end
--[[ Now the magic happens. ]]--
turtle.select(output)
turtle.craft()
--[[ Deposit anything that failed to
craft into B. This can happen. ]]--
for x = 1, invsize do
  if x ~= output then
    turtle.select(x)
    turtle.drop()
  end
end
--[[ Retrieve items from B. ]]--
for x = 1, count do
  turtle.select(ingredients[x])
  turtle.suck()
end
--[[ Retrieve items from A. ]]--
turtle.turnRight()
turtle.turnRight()
turtle.select(1)
while turtle.suck() do end
--[[ Retrieve the chests. ]]--
turtle.select(chest)
turtle.dig()
turtle.turnLeft()
turtle.turnLeft()
turtle.dig()
turtle.turnRight()

end

print("shaped_crafting loaded.")
