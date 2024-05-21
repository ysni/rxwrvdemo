import { BrowserModule } from '@angular/platform-browser';              //导入浏览器模块的方法
import { NgModule } from '@angular/core';                               //
import { HttpClient, HttpClientModule } from '@angular/common/http';    //导入http通讯模块的方法
import { FormsModule, ReactiveFormsModule } from '@angular/forms';      
//导入表单处理的功能模块 FormsModule模板驱动表单，ReactiveFormsModule响应式表单。
import { TranslateModule, TranslateLoader } from '@ngx-translate/core'; //国际化
import { TranslateHttpLoader } from '@ngx-translate/http-loader'; //国际化

import { JwtModule } from '@auth0/angular-jwt'; //JWT身份验证：用于处理基于JSON Web Tokens的用户认证。

import { AppRoutingModule } from './app-routing.module';//路由模块

// 导入多个自定义模块，用于应用中的特定功能。就是功能模块
import { ConfigModule } from './config/config.module';//设置功能
import { PlayerModule } from './shared/player/player.module';//
import { FaceModule } from './face/face.module';             //人脸功能
import { DownloadModule } from './download/download.module'; //下载功能
import { AuthModule } from './auth/auth.module';    //认证功能
import { TipsModule } from './tips/tips.module';
import { FaceParaModule } from './face-para/face-para.module'; //人脸设置
import { FaceManageModule } from './face-manage/face-manage.module'; //人脸管理

// 导入 AppComponent 和其他组件，就是界面组件
import { AppComponent } from './app.component'; //AppComonent 是angular应用的根组建,AppComponent有点类似于Qt程序的MainWindows
import { HeaderComponent } from './header/header.component';//头部组件 导航栏、搜索栏等
import { FooterComponent } from './footer/footer.component';//底部导航栏组件
import { PreviewComponent } from './preview/preview.component';//预览组件
import { AboutComponent } from './about/about.component';//关于信息组件

// 导入各种自定义指令，用于模板中实施特定行为或验证。就是导入一些公共的功能
import { TimeCompareDirective } from './shared/validators/time-compare.directive'; //时间比对功能
import { AgeCompareDirective } from './shared/validators/age-compare.directive';   //年龄比对功能
import { BenumberDirective } from './shared/validators/benumber.directive';        
import { CalculationDirective } from './shared/validators/calculation.directive';
import { ConfirmPasswordDirective } from './shared/validators/confirm-password.directive';//计算功能
import { IsIpv4Directive } from './shared/validators/is-ipv4.directive';                  //ipv4功能
import { IsIpDirective } from './shared/validators/is-ip.directive';
import { IsDecimalDirective } from './shared/validators/is-decimal.directive';
import { IsStandardTimeDirective } from './shared/validators/is-standard-time.directive';
import { Pstring32Directive } from './shared/validators/pstring32.directive';     //打印功能

//这里创建了一个TranslateHttpLoader http国际化实例
//export 有点类似于C++的public语法,在其他文件中可以使用这个
//export 和pulic又有所不同,用了export,才能用import直接导入这个方法
export function HttpLoaderFactory(http: HttpClient) {
  return new TranslateHttpLoader(http);
}

//存储方法,从本地存储中获取token
export function tokenGetterFunc(): string {
  return localStorage.getItem('token');
}

//@NgModule把()内的字典里的数据组件,指令、管道等注入到下面的class里 
//被@NgModule修饰的是模块
//被@Component修饰的是组件,就是UI组件
//被@Directive是指令,是用来动态修改UI的结构,外观和行为
//被@Pipe修饰的是管道,是用来在模板中转换数据，使其更适合显示
//被@Injectable修饰的是服务,主要用于封装可重用的业务逻辑或数据访问层
//服务是可以被注入到模块里,也可以被注入到组件里的
@NgModule({
  //模块的私有组件、指令或管道、服务
  //其他模块导入了这个模块后,不能直接使用以下模块,除非其他模块自己导入
  //类似于写在.cpp文件的import语句
  declarations: [ 
    AppComponent,
    HeaderComponent,
    FooterComponent,
    PreviewComponent,
    AboutComponent,
    TimeCompareDirective,
    AgeCompareDirective,
    BenumberDirective,
    CalculationDirective,
    ConfirmPasswordDirective,
    IsIpv4Directive,
    IsIpDirective,
    IsDecimalDirective,
    IsStandardTimeDirective,
    Pstring32Directive,
  ],
  //可以在其他类里使用的组件、管道或指令,模块或服务
  //其他模块导入了这个模块后,可以直接使用以下模块
  //类似于写在.h文件的import语句
  //不论是declarations里的组件和指令管道
  //还是imports里的模块或者providers的服务
  //要让其他模块可以不导入直接使用的话,都要在这边重写一次
  exports: [//
    HeaderComponent,
    FooterComponent,
  ],
  //导入的其他模块
  imports: [
    BrowserModule,
    HttpClientModule,
    FormsModule,
    ReactiveFormsModule,
    PlayerModule,
    ConfigModule,
    AuthModule,
    FaceModule,
    DownloadModule,
    TipsModule,
    FaceParaModule,
    FaceManageModule,
    //全局模块,可以在全局被自动注入使用,就不用每个组件都写provides[TranslateModule]
    TranslateModule.forRoot({
      loader: {
        provide: TranslateLoader,
        useFactory: HttpLoaderFactory,
        deps: [HttpClient]
      }
    }),
    AppRoutingModule,
    JwtModule.forRoot({ //全局模块
      config: {
        tokenGetter: tokenGetterFunc,
        whitelistedDomains: ['localhost'],
        blacklistedRoutes: ['localhost:4200/login']
      }
    })
  ],
  //导入的服务
  providers: [],//全局服务不用在这里写,在服务的@Injectable装饰器里设置了 providedIn: 'root'的就是全局服务,
  bootstrap: [AppComponent]
  //数组告诉 Angular 哪个组件是应用的主视图（即根组件），它是应用启动时加载的第一个视图。这通常是你的应用的入口点。
  //在大多数单页应用中，AppComponent 是唯一的 bootstrap 组件。
  //bootstrap后,中括号里的组件就被初始化了,这里是AppComponent被初始化
})
//声明一个class, { }里没有实现,因为都用@NgModule注入了各组件等,所以可以省掉很多编码
export class AppModule { }
