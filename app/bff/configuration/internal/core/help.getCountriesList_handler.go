// Copyright 2022 Teamgram Authors
//  All rights reserved.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//   http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//
// Author: teamgramio (teamgram.io@gmail.com)
//

package core

import (
	"github.com/teamgram/proto/mtproto"
	"github.com/teamgram/teamgram-server/app/service/biz/help/help"
)

// HelpGetCountriesList
// help.getCountriesList#735787a8 lang_code:string hash:int = help.CountriesList;
func (c *ConfigurationCore) HelpGetCountriesList(in *mtproto.TLHelpGetCountriesList) (*mtproto.Help_CountriesList, error) {
	// 通过 RPC 调用 biz/help 服务获取国家列表
	request := &help.TLHelpGetCountriesList{
		Constructor: help.TLConstructor_CRC32_help_getCountriesList,
	}
	result, err := c.svcCtx.Dao.HelpClient.HelpGetCountriesList(c.ctx, request)
	if err != nil {
		c.Logger.Errorf("help.getCountriesList - RPC call error: %v", err)
		// 返回空列表
		countriesList := &mtproto.Help_CountriesList{
			Countries: make([]*mtproto.Help_Country, 0),
			Hash:      0,
		}
		return mtproto.MakeTLHelpCountriesList(countriesList).To_Help_CountriesList(), nil
	}

	// 转换 help.Help_CountriesList 为 mtproto.Help_CountriesList
	return c.convertToMtprotoCountriesList(result), nil
}

// convertToMtprotoCountriesList 将 help.Help_CountriesList 转换为 mtproto.Help_CountriesList
func (c *ConfigurationCore) convertToMtprotoCountriesList(in *help.Help_CountriesList) *mtproto.Help_CountriesList {
	countries := make([]*mtproto.Help_Country, 0)
	for _, country := range in.Countries {
		mtprotoCountry := mtproto.MakeTLHelpCountry(&mtproto.Help_Country{
			Hidden:      country.Hidden,
			Iso2:        country.Iso2,
			DefaultName: country.DefaultName,
			Name:        country.Name,
		}).To_Help_Country()
		if len(country.CountryCodes) > 0 {
			mtprotoCountryCodes := make([]*mtproto.Help_CountryCode, 0, len(country.CountryCodes))
			for _, code := range country.CountryCodes {
				mtprotoCountryCodes = append(mtprotoCountryCodes, mtproto.MakeTLHelpCountryCode(&mtproto.Help_CountryCode{
					CountryCode: code.CountryCode,
					Prefixes:    code.Prefixes,
					Patterns:    code.Patterns,
				}).To_Help_CountryCode())
			}
			mtprotoCountry.CountryCodes = mtprotoCountryCodes
		}
		countries = append(countries, mtprotoCountry)
	}
	return mtproto.MakeTLHelpCountriesList(&mtproto.Help_CountriesList{
		Countries: countries,
		Hash:      -1137396670,
	}).To_Help_CountriesList()
}
