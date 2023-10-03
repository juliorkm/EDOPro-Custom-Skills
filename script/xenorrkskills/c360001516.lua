--The Hero's Journey
local s,id=GetID()
function s.initial_effect(c)
	aux.AddPreDrawSkillProcedure(c,1,false,s.flipcon,s.flipop)
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
	--condition
	return Duel.GetCurrentChain()==0 and tp==Duel.GetTurnPlayer()
		and Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>0
		and Duel.GetDrawCount(tp)>0
		and Duel.IsExistingMatchingCard(s.mfilter,tp,LOCATION_DECK,0,1,e:GetHandler(),tp)
		and Duel.GetTurnCount()>=3
end
function s.mfilter(c,tp)
	local g=Duel.GetMatchingGroup(s.thfilter,tp,LOCATION_DECK,0,nil,c)
	return c:IsMonster() and c:IsAbleToGrave()
		and g:GetClassCount(Card.GetCode)>=3
end
function s.thfilter(c,mc)
	return c:IsSpellTrap() and c:IsAbleToHand()
		and c:ListsCode(mc:GetCode())
end
function s.confilter(c,mc)
	return c:IsMonster() and c:IsFaceup()
		and (c:GetCode()==mc:GetCode() or c:ListsCode(mc:GetCode()))
end
function s.flipop(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.SelectYesNo(tp,aux.Stringid(id,0)) then return end
	Duel.Hint(HINT_SKILL_FLIP,tp,id|(1<<32))
	Duel.Hint(HINT_CARD,tp,id)
	--replace draw
	local dt=Duel.GetDrawCount(tp)
	if dt~=0 then
		_replace_count=0
		_replace_max=dt
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetCode(EFFECT_DRAW_COUNT)
		e1:SetTargetRange(1,0)
		e1:SetReset(RESET_PHASE+PHASE_DRAW)
		e1:SetValue(0)
		Duel.RegisterEffect(e1,tp)
	end
	--send monster
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,s.mfilter,tp,LOCATION_DECK,0,1,1,nil,tp)
	if #g>0 then
		Duel.SendtoGrave(g,REASON_RULE)
	end
	--reveal spells/traps
	local rvg=Duel.GetMatchingGroup(s.thfilter,tp,LOCATION_DECK,0,nil,g:GetFirst())
	local thg=aux.SelectUnselectGroup(rvg,e,tp,3,3,aux.dncheck,1,tp,HINTMSG_CONFIRM)
	if #thg==3 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		Duel.ConfirmCards(1-tp,thg)
		--check if control
		local p
		if Duel.IsExistingMatchingCard(s.confilter,tp,LOCATION_ONFIELD,0,1,nil,g:GetFirst()) then
			p=tp
		else
			p=1-tp
		end
		Duel.Hint(HINT_SELECTMSG,p,HINTMSG_ATOHAND)
		local tg=thg:Select(p,1,1,nil)
		Duel.SendtoHand(tg,nil,REASON_RULE)
		Duel.ConfirmCards(1-tp,tg)
	end
	Duel.Hint(HINT_SKILL_FLIP,tp,id|(2<<32))
end