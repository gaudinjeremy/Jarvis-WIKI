#!/bin/bash
# Here you can create functions which will be available from the commands file
# You can also use here user variables defined in your config file

jv_wiki_search () {

    local WIKI_SEARCH=$(echo $1 | tr -d ' ')

    local LIMITED_WIKI_QUERY="https://fr.wikipedia.org/w/api.php?action=opensearch&search="$WIKI_SEARCH"&prop=revisions&rvprop=content&format=json"

    local jv_pg_wk_result=$(curl -s "$LIMITED_WIKI_QUERY" | jq -r '.')

    local jv_pg_wk_definition=$(echo "$jv_pg_wk_result" | jq -r '.[2][0]')

    if [[ "$jv_pg_wk_definition" =~ "peut désigner :" || "$jv_pg_wk_definition" =~ "peut faire référence à :" || "$jv_pg_wk_definition" =~ "désigne notamment :" ]]
    then
        jv_pg_wk_definition=$(echo "$jv_pg_wk_result" | jq -r '.[2][1]')
    else
        jv_pg_wk_definition=$(echo "$jv_pg_wk_result" | jq -r '.[2][0]')
    fi

    if [ "$jv_pg_wk_definition" = "null" ] | [ -z "$jv_pg_wk_definition" ]
    then
        echo "Je n'ai rien trouvé"
    else
        echo "$jv_pg_wk_definition"
    fi

}
