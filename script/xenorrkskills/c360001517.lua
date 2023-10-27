--Master of Tokens
local s,id=GetID()
function s.initial_effect(c)
	aux.AddSkillProcedure(c,1,false,s.flipcon,s.flipop)
end
function s.flipcon(e,tp,eg,ep,ev,re,r,rp)
	--opd check
	if Duel.GetFlagEffect(ep,id)>0 then return end
	--condition
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	return aux.CanActivateSkill(tp)
	and (Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)==0
		or Duel.IsExistingMatchingCard(aux.FaceupFilter(Card.IsType,TYPE_TOKEN),e:GetHandlerPlayer(),LOCATION_ONFIELD,0,1,nil))
	and Duel.IsExistingMatchingCard(s.revfilter,tp,LOCATION_HAND,0,1,nil,tp)
end
function s.liststoken(c)
	if not c.listed_names then return false end
	for _,cardcode in ipairs(c.listed_names) do
		if Duel.GetCardTypeFromCode(cardcode)&TYPE_TOKEN==TYPE_TOKEN then
			return true
		end
	end
	return false
end
function s.revfilter(c,tp)
	return s.liststoken(c) and c:IsAbleToDeck() and not c:IsPublic()
		and Duel.IsExistingMatchingCard(s.setfilter,tp,LOCATION_DECK,0,1,nil,c)
end
function s.setfilter(c,rc)
	return not c:IsCode(rc:GetCode())
		and c:IsSpellTrap() and c:IsSSetable() and (
		s.liststoken(c) or (
			c:IsCode(97173708) --Oh Tokenbaum!
			or c:IsCode(83675475) --Token Feastevil
			or c:IsCode(14342283) --Token Stampede
			or c:IsCode(52971673) --Token Sundae
			or c:IsCode(57182235) --Token Thanksgiving
		)
	)
end
function s.flipop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SKILL_FLIP,tp,id|(1<<32))
	Duel.Hint(HINT_CARD,tp,id)
	--opd register
	Duel.RegisterFlagEffect(ep,id,0,0,0)
	--reveal card
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local g1=Duel.SelectMatchingCard(tp,s.revfilter,tp,LOCATION_HAND,0,1,1,nil,tp)
	--set card
	local g2=Duel.GetMatchingGroup(s.setfilter,tp,LOCATION_DECK,0,nil,g1:GetFirst())
	if #g2>0 then
		local sg=g2:Select(tp,1,1,nil)
		Duel.SSet(tp,sg)
	end
	--return card to top
	if #g1>0 then
		Duel.SendtoDeck(g1,nil,SEQ_DECKTOP,REASON_RULE)
	end
	--restrict extra deck summon
	local c=e:GetHandler()
	--Cannot Special Summon from the Extra Deck, except if you control a Token
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetTargetRange(1,0)
	e1:SetTarget(s.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	Duel.Hint(HINT_SKILL_FLIP,tp,id|(2<<32))
end
function s.splimit(e,c)
	return c:IsLocation(LOCATION_EXTRA) and not (Duel.IsExistingMatchingCard(aux.FaceupFilter(Card.IsType,TYPE_TOKEN),e:GetHandlerPlayer(),LOCATION_ONFIELD,0,1,nil))
end