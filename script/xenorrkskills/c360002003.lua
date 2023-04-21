--Adventure Awaits!
local s,id=GetID()
function s.initial_effect(c)
	--Activate
	aux.AddPreDrawSkillProcedure(c,1,false,s.condition,s.activate)
end
s.listed_names={34690953,39568067}
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	--opd check
	if Duel.GetFlagEffect(ep,id)>0 then return end
	--condition
	return Duel.GetCurrentChain()==0 and tp==Duel.GetTurnPlayer()
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	--opd register
	Duel.RegisterFlagEffect(ep,id,0,0,0)
	--activate only in your first turn
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(s.flipcon)
	e1:SetOperation(s.flipop)
	e1:SetReset(RESET_PHASE+PHASE_END+RESET_SELF_TURN)
	Duel.RegisterEffect(e1,tp)
end
function s.filter(c)
	return c:IsCode(34690953) or c:IsCode(39568067)
end
function s.flipcon(e,tp,eg,ep,ev,re,r,rp)
	--opd check
	if Duel.GetFlagEffect(ep,id)>1 then return end
	--condition
	return aux.CanActivateSkill(tp)
	and Duel.IsMainPhase() and not Duel.CheckPhaseActivity()
	and Duel.IsExistingMatchingCard(aux.TRUE,tp,LOCATION_HAND,0,1,nil)
	and Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_DECK,0,1,nil)
end
function s.flipop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SKILL_FLIP,tp,id|(1<<32))
	Duel.Hint(HINT_CARD,tp,id)
	--opd register
	Duel.RegisterFlagEffect(ep,id,0,0,0)
	--place 1 "Fateful Adventure" or 1 "Curse of Aramatir" to your Spell & Trap Zone from your Deck
	local tc=Duel.SelectMatchingCard(tp,s.filter,tp,LOCATION_DECK,0,1,1,nil):GetFirst()
	Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	Duel.ShuffleDeck(tp)
	Duel.BreakEffect()
	--return 1 card from your hand to your Deck
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,aux.TRUE,tp,LOCATION_HAND,0,1,1,nil)
	if #g>0 then
		Duel.SendtoDeck(g,nil,0,REASON_RULE)
	end
	Duel.Hint(HINT_SKILL_FLIP,tp,id|(2<<32))
end