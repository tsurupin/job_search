import styled from 'styled-components';
import { Link } from 'react-router';

export const Wrapper = styled.nav`
  display: flex;
  flex-flow: row wrap;
  justify-content: space-between;
  padding: 1.3rem 1.0rem;
  font-size: 2.4rem;
  box-sizing: border-box;
  background-color: #fff;
  height: 56px;
  min-height: 56px;
  padding: 4px 10%;
  border: 1px solid #f3f3f3;
 `;


export const FavoriteJobLink = styled(Link)`
  color: #8F8F8F;
  margin-top: 7px;
  margin-right: 20px;
  cursor: pointer;
`;

export const HeaderLinkList = styled.div`
  flex: 2;
  display: flex;
  justify-content: flex-end;
`;

export const Button = styled.button`
  color: #8F8F8F;
  cursor: pointer;
`;

export const BrandLink = styled(Link)`
  color: #8F8F8F;
  font-size: 1.6rem;
  font-family: '-apple-system,BlinkMacSystemFont,"Segoe UI",Roboto,Oxygen,Ubuntu,Cantarell, ' +
      '"Open Sans","Helvetica Neue",sans-serif';
  line-height: 5.0rem;
  cursor: pointer;
`;

