module QueryConstants
  OHC = Java::OrgHibernateCriterion
  OHR = Java::OrgHibernateCriterion::Restrictions
  OHF = Java::OrgHibernate::FetchMode
  OHO = Java::OrgHibernateCriterion::Order
  LEFT_JOIN = OHC::CriteriaSpecification::LEFT_JOIN
  MatchAnywhere = OHC::MatchMode::ANYWHERE
end
