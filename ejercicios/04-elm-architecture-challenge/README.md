# 04 - Elm Architecture: Challenge

Ahora que ya tenes una idea de como funciona un programa Elm, tengo un pequeño desafio para vos! Partiendo del codigo anterior, modifica el programa para que en lugar de manejar un solo counter, maneje una lista de counters, permitiendo al usuario agregar, eliminar counters y incrementar y decrementar cada uno de ellos de forma independiente.

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

