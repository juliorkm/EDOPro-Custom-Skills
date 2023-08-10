--Spooky Surprise
local s,id=GetID()
function s.initial_effect(c)
	aux.AddSkillProcedure(c,1,false,s.flipcon,s.flipop,1)
end
function s.flipcon(e,tp,eg,ep,ev,re,r,rp)
	--opd check
	if Duel.GetFlagEffect(ep,id)>0 then return end
	--condition
	return aux.CanActivateSkill(tp)
	and Duel.IsExistingTarget(aux.FaceupFilter(Card.IsCanTurnSet),tp,0,LOCATION_MZONE,1,nil)
	and Duel.IsExistingMatchingCard(s.facedownfilter1,tp,LOCATION_MZONE,0,2,nil,tp)
end
function s.facedownfilter1(c,tp)
	return c:IsPosition(POS_FACEDOWN_DEFENSE) and c:IsMonster()
		and Duel.IsExistingMatchingCard(s.facedownfilter2,tp,LOCATION_MZONE,0,1,c,c)
end
function s.facedownfilter2(c,tc)
	return c:IsPosition(POS_FACEDOWN_DEFENSE) and c:IsMonster()
		and c:GetOriginalAttribute()==tc:GetOriginalAttribute()
end
function s.flipop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SKILL_FLIP,tp,id|(1<<32))
	Duel.Hint(HINT_CARD,tp,id)
	--opd register
	Duel.RegisterFlagEffect(ep,id,0,0,0)
	--flip monsters
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEDOWN)
	local g1=Duel.SelectMatchingCard(tp,s.facedownfilter1,tp,LOCATION_MZONE,0,1,1,nil,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEDOWN)
	local g2=Duel.SelectMatchingCard(tp,s.facedownfilter2,tp,LOCATION_MZONE,0,1,1,g1:GetFirst(),g1:GetFirst(),tp)
	g1:Merge(g2)
	local attr=g1:GetFirst():GetOriginalAttribute()
	e:SetLabel(attr)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_POSCHANGE)
	local sg=Duel.SelectMatchingCard(tp,Card.IsCanTurnSet,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,g1,#g1,0,0)
	Duel.ChangePosition(g1,POS_FACEUP_DEFENSE)
	Duel.ChangePosition(sg,POS_FACEDOWN_DEFENSE)
	--cannot deal damage
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CHANGE_DAMAGE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(0,1)
	e1:SetValue(0)
	e1:SetReset(RESET_PHASE+PHASE_END,2)
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_NO_EFFECT_DAMAGE)
	e2:SetReset(RESET_PHASE+PHASE_END,2)
	Duel.RegisterEffect(e2,tp)
	--cannot special summon
	local e3=Effect.CreateEffect(e:GetHandler())
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetDescription(s.attrstr(e))
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH+EFFECT_FLAG_CLIENT_HINT)
	e3:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e3:SetReset(RESET_PHASE+PHASE_END)
	e3:SetTargetRange(1,0)
	e3:SetTarget(s.splimit)
	e3:SetLabel(attr)
	Duel.RegisterEffect(e3,tp)
	Duel.Hint(HINT_SKILL_FLIP,tp,id|(2<<32))
end
function s.splimit(e,c)
	return not c:IsAttribute(e:GetLabel())
end
function s.attrstr(e)
	local attr=e:GetLabel()
	if attr==ATTRIBUTE_WATER then
		return aux.Stringid(id,0)
	end
	if attr==ATTRIBUTE_EARTH then
		return aux.Stringid(id,1)
	end
	if attr==ATTRIBUTE_FIRE then
		return aux.Stringid(id,2)
	end
	if attr==ATTRIBUTE_WIND then
		return aux.Stringid(id,3)
	end
	if attr==ATTRIBUTE_DARK then
		return aux.Stringid(id,4)
	end
	if attr==ATTRIBUTE_LIGHT then
		return aux.Stringid(id,5)
	end
	if attr==ATTRIBUTE_DIVINE then
		return aux.Stringid(id,6)
	end
end