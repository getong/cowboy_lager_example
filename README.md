# cowboy_lager_example
cowboy lager example

An OTP application

## 初始化项目

``` shell
rebar3 new release cowboy_lager_example
cd cowboy_lager_example
```

## 添加项目依赖
编辑rebar.config:

``` erlang
{deps, [
        cowboy,
        lager
]}.
```
这里使用最新版本的cowboy和lager，下面编译的时候会自动生成rebar.lock文件，rebar.lock文件里面会有具体的版本信息和hash检验值。

也可以在rebar.config指定具体的版本信息：

``` erlang
{cowboy, "2.6.3"},
{lager, "3.7.0"}
```

## Build
编译
``` shell
$ rebar3 compile
```

## lager配置
最初的config/sys.config为：

``` erlang
[
  {cowboy_lager_example, []}
].
```
添加lager的配置文件：

``` erlang
[
%% lager日志库配置
{lager, [
        {colored, true},
                {log_root, "log"},
                {handlers, [
                        {lager_console_backend, [{level, error}]},
                        {lager_file_backend, [
                                {file, "error.log"},
                                {level, error},
                                {formatter, lager_default_formatter},
                                {formatter_config, ["=ERROR REPORT==== ", date, " ", time, " ===", sev, "(", pid, ":", module, ":", line, ") ", message, "\n\n"]},
                                {size, 10485760},
                                {date, "$D0"},
                                {count, 10}]},
                        {lager_file_backend, [
                                {file, "console.log"},
                                {level, info}
                        ]}
                ]},
                %% Any other sinks
                {extra_sinks,
                        [
                        {extra_sinks,
                                [
                                {error_logger_lager_event,
                                        [{handlers, [
                                                {lager_file_backend, [
                                                        {file, "error.log"},
                                                        {level, error}]}]
                                        }]
                                }]
                        }
                        ]}]
},
  {cowboy_lager_example, []}
].
```
更多的lager配置信息可以参考[lager](https://github.com/erlang-lager/lager)

所有的配置文件都可以集中到config/sys.config文件中，这个文件就是rebar3 release的配置文件了。

config/vm.args文件是erlang虚拟机的配置信息。

## cowboy启动
cowboy的启动文件可以参考[cowboy example](https://github.com/ninenines/cowboy/tree/master/examples)

这里使用[rest_hello_world](https://github.com/ninenines/cowboy/tree/master/examples/rest_hello_world)

添加cowboy和lager到`cowboy_lager_example/apps/cowboy_lager_example/src/cowboy_lager_example.app.src`文件：

``` erlang
{applications,
   [kernel,
    stdlib,
    lager,
    cowboy
   ]},
```
在`cowboy_lager_example/apps/cowboy_lager_example/src/cowboy_lager_example_app.erl`文件中添加：

``` erlang
    Dispatch = cowboy_router:compile([
		{'_', [
			{"/", toppage_h, []}
		]}
	]),
	{ok, _} = cowboy:start_clear(http, [{port, 18080}], #{
		env => #{dispatch => Dispatch}
	}),
```
拷贝cowboy中的`examples/rest_hello_world/src/toppage_h.erl` 到`apps/cowboy_lager_example/src`目录下面

## live启动

``` shell
rebar3 shell
```

## release发布包

```
rebar3 release
```

## tar 包

``` shell
rebar3 as prod tar
```
