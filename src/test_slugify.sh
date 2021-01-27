#!/usr/bin/env bash
source "$(dirname "$0")"/include.sh

slugify(){
  # shellcheck disable=SC2020
    echo "${1,,}" \
  | tr \
      'àáâäæãåāçćčèéêëēėęîïííīįìłñńôöòóœøōõßśšûüùúūÿžźż' \
      'aaaaaaaaccceeeeeeeiiiiiiilnnoooooooosssuuuuuyzzz' \
  | sed "s/  */-/g" \
  | sed 's/[^a-z0-9\-]/_/g'
}

test_slugify_simple(){
  assert_equals "test" "$(slugify test)"
   }

test_slugify_lowercase(){
  assert_equals "sometext" "$(slugify SomeText)"
   }

test_slugify_multiplewords(){
  assert_equals "one-two-three" "$(slugify "one two three")"
   }

test_slugify_spaces_tabs(){
  assert_equals "space-space-tab" "$(slugify "space   space    tab\t\t")"
   }

test_slugify_accents(){
  assert_equals "internationalisation" "$(slugify "IntérñâtiònålÎsation")"
   }
