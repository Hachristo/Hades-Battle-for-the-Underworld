
require "vector"

GrabberClass = {}

function GrabberClass:new()
  local grabber = {}
  local metadata = {__index = GrabberClass}
  setmetatable(grabber, metadata)

  grabber.previousMousePos = nil
  grabber.currentMousePos = nil

  grabber.grabPos = nil

  grabber.currentPile = nil
  grabber.prevPile = nil

  -- NEW: we'll want to keep track of the object (ie. card) we're holding
  grabber.heldObject = {}

  return grabber
end

function GrabberClass:update()
  self.currentMousePos = Vector(
    love.mouse.getX(),
    love.mouse.getY()
  )

  -- Click (just the first frame)
  if love.mouse.isDown(1) and self.grabPos == nil then
    self:grab()
  end
  if love.mouse.isDown(1) and self.grabPos ~= nil then
    self:drag()
  end
  -- Release
  if not love.mouse.isDown(1) and self.grabPos ~= nil then
    self:release()
  end  
end

function GrabberClass:grab()
  self.grabPos = self.currentMousePos
  -- insert mouseOvered card into grabbed stack
  for _, card in ipairs(cardTable) do
    if card.state == 1 then
      table.insert(self.heldObject, card)
      card.state = 2
    end
  end
  -- if we grabbed nothing then there is no grab position
  if #self.heldObject == 0 then
    self.grabPos = nil
  else
    -- check which pile we grabbed a card from
    local prevPrevPile = nil
    for i, pile in ipairs(pileTable) do
      for x, card in ipairs(pile.cards) do
        if self.heldObject[1] == card then
          prevPrevPile = pile
        end
      end
    end
    -- if card was grabbed from a pile set the previous pile to that pile (used for adding and removing cards from piles later)
    if prevPrevPile ~= nil then
      self.prevPile = prevPrevPile
    end
    -- grab cards below
--    local indexReached = false
--    if self.prevPile == nil then return end
--    for _, card in ipairs(self.prevPile.cards) do
--      if indexReached then
--        table.insert(self.heldObject, card)
--      end
--      if card == self.heldObject[1] then
--        indexReached = true
--      end
--    end
  end
end

function GrabberClass:drag()
  self.grabPos = self.currentMousePos
  for i, card in ipairs(self.heldObject) do
    card.position = self.grabPos + Vector(0, (i - 1) * 15)
  end
end

function GrabberClass:release()
  if self.heldObject == {} then -- we have nothing to release
    self.grabPos = nil
    return
  end

  -- find the pile we are attempting to release the stack into
  self.grabPos = self.currentMousePos
  local isValidReleasePosition = false 
  self.currentPile = nil
  for _, pile in ipairs(pileTable) do
    isValidReleasePosition = pile:checkForMouseOver(self)
    if isValidReleasePosition then
      self.currentPile = pile
      break
    end
  end
  

  if isValidReleasePosition then
    -- if there was a pile that we took the card stack from, remove those cards from the pile
    if self.prevPile ~= nil then
      for _, card in ipairs(self.heldObject) do
        self.prevPile:removeCard(card)
      end
    end
    -- if there is a pile that we are adding a card stack to, add those cards to the pile
    if self.currentPile ~= nil then
      for _, card in ipairs(self.heldObject) do
        self.currentPile:addCard(card)
      end
    end
  else
    -- if we dragged a stack but didn't drop it in a valid spot then snap the cards back to the old spot
    if self.prevPile ~= nil then
      self.prevPile:refreshPile()
    end
  end

  -- set the cards to be idle
  for _, card in ipairs(self.heldObject) do
    card.state = 0
  end

  -- clear the held object table
  for k in pairs(self.heldObject) do
    self.heldObject[k] = nil
  end
  self.grabPos = nil
end

function GrabberClass:checkValidTableauPosition()
  return true
end

function GrabberClass:checkValidAcePilePosition()
  return true
end