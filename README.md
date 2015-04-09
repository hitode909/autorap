# autorap

Full Automated Rap Singer

## PREAPRE

- Download keywordlist_furigana.csv
  - http://developer.hatena.ne.jp/ja/documents/keyword/misc/catalog
- Prepare Yahoo's Application ID
  - http://developer.yahoo.co.jp/webapi/jlp/

# RUN

```
% bundle install
% HATENA_KEYWORD_CSV_PATH=***.csv \
  YAHOO_API_TOKEN=*** \
  bundle exec -- ruby autorap.rb 'びしょ濡れミステリーハンター，お得なショッピングセンター，甘いねポッピングシャワー'
びしょ濡れミステリーハンター，お得なショッピングセンター，甘いねポッピングシャワー
びしょ濡れミステリーハンター，MUCなショッピングポーター，目眩ねミサッピングYou were...
的外れミステリーハンター，MUCなジャンピングカーター，玉井ねミサッピングYou were...
車庫入れミステリーデンター，MUCなストンピングCheetah，互生ねミサッピングYou were...
jyaco喜連ミステリーデンター，MUCなストンピングCheetah，互生ねミサッピングYou were...
jyaco喜連ミステリーCTB，MUCなジャンピングCheetah，互生ねミサッピングYou were...
jyacoセガレBatteryCTB，MUCなクリッピングCheetah，互生ねミサッピングYou were...
```
