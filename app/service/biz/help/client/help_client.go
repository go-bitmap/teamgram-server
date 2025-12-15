/*
 * WARNING! All changes made in this file will be lost!
 * Created from 'scheme.tl' by 'mtprotoc'
 *
 * Copyright (c) 2024-present,  Teamgram Authors.
 *  All rights reserved.
 *
 * Author: teamgramio (teamgram.io@gmail.com)
 */

package help_client

import (
	"context"

	"github.com/teamgram/proto/mtproto"
	"github.com/teamgram/teamgram-server/app/service/biz/help/help"

	"github.com/zeromicro/go-zero/zrpc"
)

var _ *mtproto.Bool

type HelpClient interface {
	HelpGetCountriesList(ctx context.Context, in *help.TLHelpGetCountriesList) (*help.Help_CountriesList, error)
}

type defaultHelpClient struct {
	cli zrpc.Client
}

func NewHelpClient(cli zrpc.Client) HelpClient {
	return &defaultHelpClient{
		cli: cli,
	}
}

// HelpGetCountriesList
// help.getCountriesList = help.CountriesList;
func (m *defaultHelpClient) HelpGetCountriesList(ctx context.Context, in *help.TLHelpGetCountriesList) (*help.Help_CountriesList, error) {
	client := help.NewRPCHelpClient(m.cli.Conn())
	return client.HelpGetCountriesList(ctx, in)
}
