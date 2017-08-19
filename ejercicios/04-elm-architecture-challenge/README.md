# 04 - Elm Architecture: Challenge

Ahora que ya tenés una idea de cómo funciona un programa Elm, tengo un pequeño desafío para vos! Partiendo del código anterior, modifica el programa para que en lugar de manejar un solo counter, maneje una lista de counters, permitiendo al usuario agregar y eliminar counters, e incrementar y decrementar cada uno de ellos de forma independiente.

## Hint: partiremos del siguiente modelo:

```elm
type alias Counter =
    { id : Int
    , count : Int
    }


type alias Model =
    { counters : List Counter
    , seed : Int
    }
```
