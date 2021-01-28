#!/usr/bin/env bash
source "$(dirname "$0")"/include.sh
#-# SLUGIFY
#-# creating slugs from sentences, urls, accents, ...

slugify2() {
  # shellcheck disable=SC2020
  echo "${1,,}" |
    tr 'àáâäæãåāçćčèéêëēėęîïííīįìłñńôöòóœøōõßśšûüùúūÿžźż' 'aaaaaaaaccceeeeeeeiiiiiiilnnoooooooosssuuuuuyzzz' |
    sed "s/https*/ /" |
    xargs |
    tr "@#$%^&*;,.:()<>!?/+=" " " |
    sed "s/^  *//g" |
    sed "s/  *$//g" |
    sed "s/  */-/g" |
    sed 's/[^a-z0-9\-]/_/g'
}

slugify() {
  # shellcheck disable=SC2020
  echo "${1,,}" | xargs | tr \
    'àáâäæãåāçćčèéêëēėęîïííīįìłñńôöòóœøōõßśšûüùúūÿžźż' \
    'aaaaaaaaccceeeeeeeiiiiiiilnnoooooooosssuuuuuyzzz' |
  awk '{
    gsub(/https?/,"",$0); gsub(/[\[\]@#$%^&*;,.:()<>!?\/+=_]/," ",$0);
    gsub(/^  */,"",$0); gsub(/  *$/,"",$0); gsub(/  */,"-",$0); gsub(/[^a-z0-9\-]/,"");
    print;
    }' | cut -c1-50
}

test_slugify_accents() { assert_equals "internationalisation" "$(slugify "IntérñâtiònålÎsÅtion")"; }
test_slugify_charmap() { assert_equals "12345" "$(slugify "1℘2∃÷3∞¹4♥↔5")"; }
test_slugify_emojis() { assert_equals "1234" "$(slugify "[1😀2❓3⚠4️]")"; }
test_slugify_lowercase() { assert_equals "sometext" "$(slugify SomeText)"; }
test_slugify_multi_lines() { assert_equals "line1-line2-line3" "$(slugify "line1
line2
line3")"; }
test_slugify_multi_space() { assert_equals "space-space" "$(slugify "  space   space    ")"; }
test_slugify_multi_words() { assert_equals "one-two-three" "$(slugify "one two three")"; }
test_slugify_path_email() { assert_equals "peter-forret-gmail-com" "$(slugify "peter.forret@gmail.com")"; }
test_slugify_path_file() { assert_equals "var-log-test-file-example-txt" "$(slugify "/var/log/test/file.example.txt")"; }
test_slugify_path_url() { assert_equals "example-com-log-file-example-txt" "$(slugify "https://example.com/log/file_example.txt")"; }
test_slugify_punctuation() { assert_equals "comma-colon-test-or-not" "$(slugify "comma,colon: test; or not?!")"; }
test_slugify_simple_test() { assert_equals "test" "$(slugify test)"; }
test_slugify_very_long() { assert_equals "one-two-three-four-five-six-seven-eight-nine-ten-e" "$(slugify "one two three four five six seven eight nine ten eleven twelve")"; }
