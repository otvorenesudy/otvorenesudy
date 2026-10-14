# frozen_string_literal: true

# Brings court and person names from the state's sources and the datasets in data/ to the form stored in the
# database: "KS v BA" becomes "Krajský súd Bratislava", "JUDr. NOVÁK Ján, PhD." becomes "JUDr. Ján Novák, PhD.".
# Ported from the Rails 3 app's JusticeGovSk::Helper::Normalizer by way of otvorenesudy-api's Legacy::Normalizer, which
# adds the courts renamed in 2024 (Mestský súd).
module NameNormalizer
  extend self

  # Applied in order: later spellings rely on the spaces and words the earlier ones produce.
  COURT_SPELLINGS = [
    [/[-,]/, ''],
    [/1/, ' I '],
    [/2/, ' II '],
    [/3/, ' III '],
    [/4/, ' IV '],
    [/5/, ' V '],
    [/lll|III/i, ' III '],
    [/okolie/i, ' okolie '],
    [/Kraj.\s*súd/, 'Krajský súd'],
    [/B\.?\s*Bystrica/, 'Banská Bystrica'],
    [/D\.\s*Kubín/, 'Dolný Kubín'],
    [/\A|\z/, ' '],
    [/\s+v\s+BA/, ' Bratislava'],
    [/\s+v\s+ZA/, ' Žilina'],
    [/\s+v\s+Bansk(?:á|ej)\s+Bystric(?:a|i)/i, ' Banská Bystrica'],
    [/\s+v\s+Bratislav(?:a|e)/i, ' Bratislava'],
    [/\s+v\s+Košic(?:a|iach)/i, ' Košice'],
    [/\s+v\s+Nitr(?:a|e)/i, ' Nitra'],
    [/\s+v\s+Prešove?/i, ' Prešov'],
    [/\s+v\s+Trenčíne?/i, ' Trenčín'],
    [/\s+v\s+Trnav(?:a|e)/i, ' Trnava'],
    [/\s+v\s+Žilin(?:a|e)/i, ' Žilina'],
    [/ +/, ' '],
    [/\A\s+|\s+\z/, ''],
    [%r{n/B}i, 'nad Bebravou'],
    [%r{n/V}i, 'nad Váhom'],
    [%r{n/T|n\.T\.}i, 'nad Topľou'],
    [%r{n/H}i, 'nad Hronom'],
    [/Najvyšší\s*súd\s*(?:SR|Slovenskej*\srepubliky)?/i, 'Najvyšší súd Slovenskej republiky'],
    [/ŠTS(?:\s*v\s*Pezinku)?/i, 'Špecializovaný trestný súd'],
    [/MS\s*SR/, 'Ministerstvo spravodlivosti Slovenskej republiky'],
    [/NS\s*SR/, 'Najvyšší súd Slovenskej republiky'],
    [/Najvyšší\ssprávny\ssúd\s*(?:SR|Slovenskej\srepubliky)?/i, 'Najvyšší správny súd'],
    [/\AOkresný súd Bratislava (I|II|III|IV)\z/i, 'Mestský súd Bratislava \1'],
    [/\AOkresný súd Košice I\z/i, 'Mestský súd Košice'],
    [/\./, '']
  ].freeze

  COURT_ABBREVIATIONS = {
    'KS' => 'Krajský súd',
    'OS' => 'Okresný súd',
    'BA' => 'Bratislava',
    'KE' => 'Košice',
    'ZA' => 'Žilina',
    'BB' => 'Banská Bystrica'
  }.freeze

  PERSON_PREFIXES = [
    'abs. v. š.', 'akad.', 'akad. arch.', 'akad. mal.', 'akad. soch.', 'arch.', 'Bc.', 'Bc. arch.', 'BcA.', 'B.Ed.',
    'B.Sc.', 'Bw. (VWA)', 'doc.', 'Dr.', 'Dr hab.', 'Dr inž.', 'Dr. jur.', 'Dr.h.c.', 'Dr.ir.', 'Dr.phil.', 'Eng.',
    'ICDr.', 'Ing.', 'Ing. arch.', 'JUC.', 'JUDr.', 'Kfm.', 'Kfm. (FH)', 'Lic.', 'Mag', 'Mag.', 'Mag. (FH)', 'Mag. iur',
    'Magistra Artium', 'Mag.rer.nat.', 'MDDr.', 'MgA.', 'Mgr.', 'Mgr. art.', 'mgr inž.', 'Mgr. phil.', 'MMag.',
    'Mr.sc.', 'MSDr.', 'MUc.', 'MUDr.', 'MVc.', 'MVDr.', 'PaedDr.', 'PharmDr.', 'PhDr.', 'PhMr.', 'prof.',
    'prof. mpx. h.c.', 'prof.h.c.', 'RCDr.', 'RNDr.', 'RSDr.', 'ThDr.', 'ThLic.'
  ].freeze

  PERSON_SUFFIXES = [
    'ArtD.', 'BA', 'BA (Hons)', 'BBA', 'BBS', 'BBus', 'BBus (Hons)', 'BS', 'BSBA', 'BSc', 'Cert Mgmt', 'CPA', 'CSc.',
    'DDr.', 'Dipl. Ing.', 'Dipl. Kfm.', 'Dipl.ECEIM', 'DiS.', 'DiS.art', 'Dr.', 'Dr.h.c.', 'DrSc.', 'DSc.', 'EMBA',
    'E.M.M.', 'Eqm.', 'Litt.D.', 'LL.A.', 'LL.B.', 'LL.M.', 'M.A.', 'MAE', 'MAS', 'MBA', 'MBSc', 'M.C.L.', 'MEng.',
    'MIM', 'MMBA', 'MPH', 'M.Phil.', 'MS', 'MSc', 'M.S.Ed.', 'Ph.D.', 'PhD.', 'prom. biol.', 'prom. ek.', 'prom. fil.',
    'prom. filol.', 'prom. fyz.', 'prom. geog.', 'prom. geol.', 'prom. hist.', 'prom. chem.', 'prom. knih.',
    'prom. logop.', 'prom. mat.', 'prom. nov.', 'prom. ped.', 'prom. pharm.', 'prom. práv.', 'prom. psych.',
    'prom. vet.', 'prom. zub.', 'ThD.'
  ].freeze

  def court_name(value)
    value = COURT_SPELLINGS.reduce(value.to_s) { |name, (pattern, replacement)| name.gsub(pattern, replacement) }

    value.split(/\s+/).map { |word| court_name_word(word) }.join(' ')
  end

  def person_name(value, reverse: false)
    partition_person_name(value, reverse:)[:value]
  end

  def partition_person_name(value, reverse: false)
    parts = split_person_name(value.to_s)
    names = ordered_names(parts, reverse:)

    {
      unprocessed: value.to_s.strip,
      value: compose_person_name(names, parts),
      prefix: parts[:prefixes].join(' ').presence,
      first: (names.first if names.size >= 2),
      middle: (names[1..-2].join(' ') if names.size >= 3),
      last: names.last.to_s,
      suffix: parts[:suffixes].join(' ').presence,
      addition: parts[:additions].join(' ').presence,
      flags: parts[:flags],
      role: parts[:role]
    }
  end

  private

  def court_name_word(word)
    return COURT_ABBREVIATIONS[word] if COURT_ABBREVIATIONS.key?(word)
    return word if word.match?(/\A(I|V)+\z/)
    return 'Slovenskej republiky' if word.match?(/\ASR\z/i)
    return word.downcase if word.match?(/\A(a|v|nad|pre|súd|okolie|trestný|republiky)\z/i)

    word.titlecase
  end

  def split_person_name(value)
    parts = { prefixes: [], suffixes: [], additions: [], uppercase: [], mixedcase: [], flags: [], role: nil }
    spokesperson = value.match(/(?:(?:,\s+)?hovorca)?\s+KS\s+(?:v\s+)?(?<municipality>.+)\z/i)

    if spokesperson
      parts[:flags] << :representative
      parts[:role] = spokesperson_role(spokesperson[:municipality])
      value = value.sub(/((,\s+)?hovorca\s+)?KS\s+(v\s+)?.+\z/i, '')
    end

    value = value.strip.gsub(/[,;()]/, '').gsub(/(\.+\s*)+/, '. ').gsub(/\s*-\s*/, '-')
    value.split(/\s+/).each { |part| classify_person_name_part(part.strip, parts) }

    parts.merge(prefixes: parts[:prefixes].uniq, suffixes: parts[:suffixes].uniq)
  end

  def classify_person_name_part(part, parts)
    key = person_name_key(part)

    if person_prefixes.key?(key)
      parts[:prefixes] << person_prefixes[key]
    elsif person_suffixes.key?(key)
      parts[:suffixes] << person_suffixes[key]
    elsif part.include?('.')
      classify_abbreviation(part, parts)
    else
      bucket = part.upcase == part ? :uppercase : :mixedcase
      parts[bucket] << part.split('-').map(&:titlecase).join(' - ')
    end
  end

  # "rod." marks a birth name; "ml." and "st." tell apart relatives of the same name.
  def classify_abbreviation(part, parts)
    parts[:flags] << :born if part.match?(/rod\./i)

    return unless part.match?(/(ml|st)\./)

    parts[:flags] << :relative
    parts[:additions] << part
  end

  def ordered_names(parts, reverse:)
    names = parts[:mixedcase] + parts[:uppercase]

    if reverse
      names = names.size >= 3 ? [names[-1], *names[0..-2]] : names.reverse
    end

    parts[:flags].include?(:born) ? names.insert(-2, 'rod.') : names
  end

  def compose_person_name(names, parts)
    value = names.join(' ')
    value = "#{parts[:prefixes].join(' ')} #{value}" if parts[:prefixes].any?
    value = "#{value} #{parts[:additions].join(' ')}" if parts[:additions].any?
    value = "#{value}, #{parts[:suffixes].join(' ')}" if parts[:suffixes].any?

    return value unless parts[:role]

    value.blank? ? parts[:role] : "#{value}, #{parts[:role].downcase_first}"
  end

  def spokesperson_role(municipality)
    place = 'Trenčíne' if municipality.match?(/(TN|Trenčín(e)?)/)
    place ||= 'Trnave' if municipality.match?(/(TT|Trnav(a|e))/)

    "Hovorca krajského súdu v #{place}"
  end

  def person_prefixes
    @person_prefixes ||= PERSON_PREFIXES.index_by { |prefix| person_name_key(prefix) }
  end

  def person_suffixes
    @person_suffixes ||= PERSON_SUFFIXES.index_by { |suffix| person_name_key(suffix) }
  end

  def person_name_key(value)
    ascii = value.unicode_normalize(:nfkd).encode('ASCII', invalid: :replace, undef: :replace, replace: '')

    ascii.downcase.gsub(/[\s.,;\-()]/, '').to_sym
  end
end
