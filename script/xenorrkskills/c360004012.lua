--Little Guys Stick Together
local s,id=GetID()
function s.initial_effect(c)
	aux.AddSkillProcedure(c,1,false,s.flipcon,s.flipop,1)
end
function s.flipcon(e,tp,eg,ep,ev,re,r,rp)
	--condition
	return aux.CanActivateSkill(tp)
	and Duel.CheckLPCost(tp,2000)
end
function s.lvfilter(c)
	return not c:IsLevelBelow(3) and not c:IsRankBelow(3)
end
function s.tg(e,c)
	local g=Duel.GetMatchingGroup(s.lvfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,nil)
	return #g==0 and (c:IsLevelBelow(3) or c:IsRankBelow(3))
end
function s.defval(e,c)
	local g,atk=Duel.GetMatchingGroup(Card.IsFaceup,e:GetHandlerPlayer(),LOCATION_MZONE,0,nil):GetMaxGroup(Card.GetAttack)
	return atk
end
function s.deffilter(c,e)
	local g=Duel.GetMatchingGroup(s.lvfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,nil)
	return #g==0 and (c:IsLevelBelow(3) or c:IsRankBelow(3)) and c:IsAttackPos() and c:IsCanChangePosition()
end
function s.poscon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(s.lvfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,nil)
	return #g==0 and c:IsAttackPos()
end
function s.posop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(s.deffilter,tp,LOCATION_MZONE,0,nil,e)
	if #g>0 then
		Duel.Hint(HINT_CARD,tp,id)
		Duel.ChangePosition(g,POS_FACEUP_DEFENSE)
	end
end
function s.flipop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SKILL_FLIP,tp,id|(1<<32))
	Duel.Hint(HINT_CARD,tp,id)
	Duel.PayLPCost(tp,2000)
	--monsters you control gain DEF
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_UPDATE_DEFENSE)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetTarget(s.tg)
	e1:SetValue(s.defval)
	e1:SetReset(RESET_PHASE+PHASE_END,2)
	Duel.RegisterEffect(e1,tp)
	--change to defense position
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetCategory(CATEGORY_POSITION)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_PHASE+PHASE_BATTLE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetCountLimit(1)
	e2:SetCondition(s.poscon)
	e2:SetOperation(s.posop)
	e2:SetReset(RESET_PHASE+PHASE_END,2)
	Duel.RegisterEffect(e2,tp)
	--flip during End phase
	local e3=Effect.CreateEffect(e:GetHandler())
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_PHASE+PHASE_END)
	e3:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e3:SetCountLimit(1)
	e3:SetCondition(s.unflipcon)
	e3:SetOperation(s.unflipop)
	e3:SetLabel(Duel.GetTurnCount())
	e3:SetReset(RESET_PHASE+PHASE_END,2)
	Duel.RegisterEffect(e3,tp)
end
function s.unflipcon(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	return Duel.GetTurnCount()~=e:GetLabel()
end
function s.unflipop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SKILL_FLIP,tp,id|(2<<32))
end