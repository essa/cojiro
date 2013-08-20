define [
  'modules/translatable/model'
  'modules/translatable/in-place-field'
], (Model, InPlaceField) ->

  class Translatable

    Translatable.Model = Model
    Translatable.InPlaceField = InPlaceField
