import { enableProdMode } from '@angular/core';
// from '@angular/core' 表示从 Angular 的核心包中导入 enableProdMode 函数。这里有几个关键点需要理解：
// @angular/core 是 Angular 框架的基础库，其中包含了大量用于构建和运行 Angular 应用程序的基本工具和装饰器。
// enableProdMode 是一个特殊的函数，用于在生产环境中启动 Angular 应用。当调用此函数时，Angular 会关闭开发者模式中的一些检查和辅助工具
// 就是调用这个函数加速运行

import { platformBrowserDynamic } from '@angular/platform-browser-dynamic';
// @angular/platform-browser-dynamic 客户端动态编译 Angular 应用的包
// @angular/platform-browser 客户端静态编译 Angular 应用的包
// platformBrowserDynamic 是一个用于启动应用的函数，它提供了一种方法来告诉Angular在浏览器中启动哪个模块。

import { AppModule } from './app/app.module';
// 是应用的根模块，包含了应用的组件和服务等配置

import { environment } from './environments/environment';
// environment 包含了环境相关的变量，这通常用于区分开发环境和生产环境。
//这个文件可以根据不同的构建目标（如开发或生产）进行配置


if (environment.production) {
  enableProdMode();
}
// 检查是否是生产环境,如果是生产环境
//调用 enableProdMode() 来启用生产模式
//这会关闭Angular在开发模式下的一些调试和检查功能，从而优化应用性能

platformBrowserDynamic().bootstrapModule(AppModule)
  .catch(err => console.error(err));
//调用platformBrowserDynamic()里的bootstrapModule()方法来启动根模块,根模块是AppModule
//这是Angular应用启动的核心。这个函数负责编译应用的组件和模块，然后在浏览器中加载它们。
//.catch(err => console.error(err)) 是一个错误处理回调，用于捕获和打印在模块启动过程中可能发生的任何错误。
