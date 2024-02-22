import std/[asyncdispatch, net, unittest]
import simplestatsdclient

suite "Syncronous":
  setup:
    let client = newStatsDClient("127.0.0.1", Port(8125))
  
  test "Counter":
    client.counter("test.counter", 1)
  
  test "Gauge":
    client.gauge("test.gauge", 2.0)
    client.increment("test.gauge", 2.0)

suite "Asyncronous":
  setup:
    let client = newAsyncStatsDClient("127.0.0.1", Port(8125))
  
  test "Counter":
    proc asyncCounter() {.async.} =
      await client.counter("test.counter", 2)
    waitFor(asyncCounter())

  test "Gauge":
    proc asyncGauge() {.async.} =
      await client.gauge("test.gauge", 2.0)
      await client.increment("test.gauge", 2.0)
    waitFor(asyncGauge())
