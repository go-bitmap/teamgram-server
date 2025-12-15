/*
 * Created from 'scheme.tl' by 'mtprotoc'
 *
 * Copyright (c) 2021-present,  Teamgram Studio (https://teamgram.io).
 *  All rights reserved.
 *
 * Author: teamgramio (teamgram.io@gmail.com)
 */

package core

import (
	"fmt"

	"github.com/teamgram/teamgram-server/app/service/biz/help/help"
	"github.com/teamgram/teamgram-server/app/service/biz/help/internal/dal/dataobject"
	"github.com/zeromicro/go-zero/core/jsonx"
	"google.golang.org/protobuf/types/known/wrapperspb"
)

// HelpGetCountriesList
// help.getCountriesList = help.CountriesList;
func (c *HelpCore) HelpGetCountriesList(in *help.TLHelpGetCountriesList) (*help.Help_CountriesList, error) {
	countriesList := &help.Help_CountriesList{
		Countries: make([]*help.Help_Country, 0),
		Hash:      0,
	}

	// 从数据库查询所有国家数据
	countryDOList, err := c.svcCtx.Dao.HelpCountryDAO.SelectAll(c.ctx)
	if err != nil {
		c.Logger.Errorf("help.getCountriesList - SelectAll error: %v", err)
		return countriesList, nil
	}

	// 转换数据库对象为 help.Help_Country 对象
	for _, do := range countryDOList {
		country := c.convertToHelpCountry(&do)
		if country != nil {
			countriesList.Countries = append(countriesList.Countries, country)
		}
	}

	// 计算 hash（简单实现，可以根据需要改进）
	hash := int32(len(countriesList.Countries))
	countriesList.Hash = hash

	return countriesList, nil
}

// convertToHelpCountry 将数据库对象转换为 help.Help_Country
func (c *HelpCore) convertToHelpCountry(do *dataobject.HelpCountryDO) *help.Help_Country {
	var countryCodes []*help.Help_CountryCode

	// 解析 prefixes JSON
	var prefixes []string
	if do.Prefixes != "" {
		if err := jsonx.UnmarshalFromString(do.Prefixes, &prefixes); err != nil {
			c.Logger.Errorf("convertToHelpCountry - unmarshal prefixes error: %v", err)
		}
	}

	// 解析 patterns JSON
	var patterns []string
	if do.Patterns != "" {
		if err := jsonx.UnmarshalFromString(do.Patterns, &patterns); err != nil {
			c.Logger.Errorf("convertToHelpCountry - unmarshal patterns error: %v", err)
		}
	}

	// 构建 CountryCodes
	if do.CountryCode > 0 {
		// 将 int32 类型的 country_code 转换为字符串格式（如 "+86"）
		countryCodeStr := fmt.Sprintf("+%d", do.CountryCode)
		countryCode := &help.Help_CountryCode{
			CountryCode: countryCodeStr,
			Prefixes:    prefixes,
			Patterns:    patterns,
		}
		countryCodes = []*help.Help_CountryCode{countryCode}
	}

	// 处理 Name 字段（如果 name 不为空，则使用 name，否则使用 default_name）
	var name *wrapperspb.StringValue
	if do.Name != "" {
		name = wrapperspb.String(do.Name)
	} else if do.DefaultName != "" {
		name = wrapperspb.String(do.DefaultName)
	}

	return &help.Help_Country{
		Hidden:       do.Hidden,
		Iso2:         do.Iso2,
		DefaultName:  do.DefaultName,
		Name:         name,
		CountryCodes: countryCodes,
	}
}
