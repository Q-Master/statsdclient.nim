import std/[net, asyncdispatch, asyncnet]


type
  StatsDClient* = ref StatsDClientObj
  AsyncStatsDClient* = ref AsyncStatsDClientObj

  StatsDBaseObj {.inheritable.} = object
    host: string
    port: Port

  StatsDClientObj = object of StatsDBaseObj
    socket: Socket

  AsyncStatsDClientObj = object of StatsDBaseObj
    socket: AsyncSocket


proc newStatsDClient*(host: string, port: Port): StatsDClient =
  result.new
  result.socket = newSocket(AF_INET, SOCK_DGRAM, IPPROTO_UDP, buffered = false)
  result.host = host
  result.port = port


proc newAsyncStatsDClient*(host: string, port: Port): AsyncStatsDClient = 
  result.new
  result.socket = newAsyncSocket(AF_INET, SOCK_DGRAM, IPPROTO_UDP, buffered = false)
  result.host = host
  result.port = port


proc counter*(self: StatsDClient|AsyncStatsDClient, key: string, value: SomeInteger|SomeFloat) {.multisync.} =
  await self.socket.sendTo(self.host, self.port, key & ":" & $value & "|c\n")

proc timer*(self: StatsDClient|AsyncStatsDClient, key: string, value: SomeInteger|SomeFloat) {.multisync.} =
  await self.socket.sendTo(self.host, self.port, key & ":" & $value & "|ms\n")

proc gauge*(self: StatsDClient|AsyncStatsDClient, key: string, value: SomeInteger|SomeFloat) {.multisync.} =
  await self.socket.sendTo(self.host, self.port, key & ":" & $value & "|g\n")
    
proc increment*(self: StatsDClient|AsyncStatsDClient, key: string, value: SomeInteger|SomeFloat) {.multisync.} =
  await self.socket.sendTo(self.host, self.port, key & ":+" & $value & "|g\n")

proc decrement*(self: StatsDClient|AsyncStatsDClient, key: string, value: SomeInteger|SomeFloat) {.multisync.} =
  await self.socket.sendTo(self.host, self.port, key & ":-" & $value & "|g\n")

proc sets*(self: StatsDClient|AsyncStatsDClient, key: string, value: SomeInteger|SomeFloat) {.multisync.} =
  await self.socket.sendTo(self.host, self.port, key & ":" & $value & "|s\n")
