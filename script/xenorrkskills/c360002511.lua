--Scions of the Ice Dragons
local s,id=GetID()
function s.initial_effect(c)
	aux.AddSkillProcedure(c,1,false,s.flipcon,s.flipop)
end
s.listed_names={136000001, 136000002, 136000003}
function s.flipcon(e,tp,eg,ep,ev,re,r,rp)
	--opd check
	if Duel.GetFlagEffect(ep,id)>0 then return end
	--condition
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	return aux.CanActivateSkill(tp)
	and Duel.IsExistingMatchingCard(aux.TRUE,tp,LOCATION_HAND,0,1,nil)
	and Duel.IsExistingMatchingCard(s.tfilter,tp,LOCATION_MZONE,0,1,nil,e,ft,tp)
	and Duel.IsPlayerCanSpecialSummonMonster(tp,136000001,0,TYPES_TOKEN,600,600,2,RACE_DRAGON,ATTRIBUTE_WATER)
	and Duel.IsPlayerCanSpecialSummonMonster(tp,136000002,0,TYPES_TOKEN,800,800,3,RACE_DRAGON,ATTRIBUTE_WATER)
	and Duel.IsPlayerCanSpecialSummonMonster(tp,136000003,0,TYPES_TOKEN+TYPE_TUNER,1000,1000,4,RACE_DRAGON,ATTRIBUTE_WATER)
end
function s.tfilter(c,e,ft,tp)
	return c:IsAttribute(ATTRIBUTE_WATER) and c:IsLevelAbove(6) and c:IsReleasable()
		and ((c:GetSequence()>4 and ft>=3) or (c:GetSequence()<=4 and (ft+1)>=3))
		and not Duel.IsPlayerAffectedByEffect(tp,CARD_BLUEEYES_SPIRIT)
end
function s.edfilter(c,e,code)
	return c:GetCode()==code or not 
	(c:IsAttribute(ATTRIBUTE_WATER) 
		and c:IsLevelAbove(6))
end
function s.flipop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SKILL_FLIP,tp,id|(1<<32))
	Duel.Hint(HINT_CARD,tp,id)
	--opd register
	Duel.RegisterFlagEffect(ep,id,0,0,0)
	--return card to bottom
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,aux.TRUE,tp,LOCATION_HAND,0,1,1,nil)
	if #g>0 then
		Duel.SendtoDeck(g,nil,SEQ_DECKBOTTOM,REASON_RULE)
	end
	--tribute water monster
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local g2=Duel.SelectMatchingCard(tp,s.tfilter,tp,LOCATION_MZONE,0,1,1,nil,e,ft,tp)
	local tc=g2:GetFirst()
	if not tc then return end
	local code=tc:GetCode()
	Duel.Release(tc,REASON_RULE)
	--summon tokens
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,3,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,3,tp,0)
	for _, tokenId in ipairs({136000001, 136000002, 136000003}) do
		local c=e:GetHandler()
		local token=Duel.CreateToken(tp,tokenId)
		Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP)
		-- Cannot Special Summon monsters from Extra Deck except lv6+ waters with different name
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetRange(LOCATION_MZONE)
		e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
		e1:SetAbsoluteRange(tp,1,0)
		e1:SetTarget(function(_,c) return c:IsLocation(LOCATION_EXTRA) and s.edfilter(c,e,code) end)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		token:RegisterEffect(e1,true)
		-- Lizard check
		local e2=aux.createContinuousLizardCheck(c,LOCATION_MZONE,function(_,c) return s.edfilter(c,e,code) end)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		token:RegisterEffect(e2,true)
	end
	Duel.SpecialSummonComplete()
	Duel.Hint(HINT_SKILL_FLIP,tp,id|(2<<32))
end