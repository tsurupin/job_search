import styled from 'styled-components';
import colors from 'styles/colors';
import fonts from 'styles/fonts';

export const Wrapper = styled.div`
  margin-top: 5px;
  display: flex;
`;


export const Icon = styled.div`
  margin-left: 0;
  width: 18px;
  height: 18px;
  color: ${colors.tagColor};
`;

export const Tag = styled.span`
  margin-left: 5px;
  ${fonts('font-small')}
  color: ${colors.primaryColor};
`;
