--Card Recycler
local s,id=GetID()
function s.initial_effect(c)
	aux.AddSkillProcedure(c,1,false,aux.FALSE,nil, 1)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_STARTUP)
		e1:SetRange(0x5f)
		e1:SetCountLimit(1)
		e1:SetOperation(s.op) 
		c:RegisterEffect(e1)
end
function s.op(e,tp,eg,ep,ev,re,r,rp)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_DRAW)
		e1:SetCountLimit(1)
		e1:SetCondition(s.flipcon)
		e1:SetOperation(s.flipop)
		Duel.RegisterEffect(e1,tp)
end
function s.flipcon(e,tp,eg,ep,ev,re,r,rp)
	--twice per duel check
	if Duel.GetFlagEffect(ep,id)>1 then return end
	--condition
	return Duel.GetCurrentPhase()==PHASE_DRAW and Duel.IsTurnPlayer(tp)
	and Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_HAND,0,1,e:GetHandler())
	and Duel.GetTurnCount()>=3 and Duel.IsPlayerCanDraw(tp)
end
function s.filter(c)
	return c:IsAbleToDeck() and not c:IsPublic()
end
function s.flipop(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.SelectYesNo(tp,aux.Stringid(id,0)) then return end
	Duel.Hint(HINT_SKILL_FLIP,tp,id|(1<<32))
	Duel.Hint(HINT_CARD,tp,id)
	--flag register
	Duel.RegisterFlagEffect(ep,id,0,0,0)
	--reveal card
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,s.filter,tp,LOCATION_HAND,0,1,1,nil)
	Duel.ConfirmCards(1-tp,g)
	if #g>0 then
		Duel.SendtoDeck(g,nil,1,REASON_RULE)
	end
	--draw 1
	Duel.Draw(tp,1,REASON_RULE)
	Duel.Hint(HINT_SKILL_FLIP,tp,id|(2<<32))
end