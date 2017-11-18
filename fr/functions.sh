#!/bin/bash
# Here you can create functions which will be available from the commands file
# You can also use here user variables defined in your config file

jv_wiki(){

    local WIKI_SEARCH=$(echo $1 | tr -d ' ')
    local LIMITED_WIKI_QUERY="https://fr.wikipedia.org/w/api.php?action=opensearch&search="$WIKI_SEARCH"&prop=revisions&rvprop=content&format=json"
    local jv_wiki_result=$(curl -s "$LIMITED_WIKI_QUERY" | jq -r '.')
    local jv_wiki_definition=$(echo "$jv_wiki_result" | jq -r '.[2][0]')

    if [[ "$jv_wiki_definition" =~ "peut désigner :" || "$jv_wiki_definition" =~ "peut faire référence à :" || "$jv_wiki_definition" =~ "désigne notamment :" ]]
    then
        jv_wiki_definition=$(echo "$jv_wiki_result" | jq -r '.[2][1]')
    else
        jv_wiki_definition=$(echo "$jv_wiki_result" | jq -r '.[2][0]')
    fi

    if [ "$jv_wiki_definition" = "null" ] | [ -z "$jv_wiki_definition" ]
    then
        echo "Je n'ai rien trouvé"
    else
        echo "$jv_wiki_definition"
    fi
}
